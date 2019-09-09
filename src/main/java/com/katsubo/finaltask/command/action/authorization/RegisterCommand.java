package com.katsubo.finaltask.command.action.authorization;

import com.katsubo.finaltask.command.CommandException;
import com.katsubo.finaltask.command.CommandResult;
import com.katsubo.finaltask.command.action.Command;
import com.katsubo.finaltask.entity.*;
import com.katsubo.finaltask.service.ServiceException;
import com.katsubo.finaltask.service.UserInfoService;
import com.katsubo.finaltask.service.UserService;
import com.katsubo.finaltask.service.impl.UserInfoServiceImpl;
import com.katsubo.finaltask.service.impl.UserServiceImpl;
import com.katsubo.finaltask.util.ResourceManager;
import com.katsubo.finaltask.util.menu.Menu;
import com.katsubo.finaltask.util.menu.MenuFactory;
import com.katsubo.finaltask.validate.UserInfoValidator;
import com.katsubo.finaltask.validate.UserValidator;
import com.katsubo.finaltask.validate.Validator;
import com.katsubo.finaltask.validate.ValidatorException;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.katsubo.finaltask.util.Constances.USER;

/**
 * The type Register command.
 */
public class RegisterCommand implements Command {
    private static final String ERROR = "error";
    private static final Logger logger = LogManager.getLogger(RegisterCommand.class);
    private static final String LOGIN = "login";
    private static final String PASSWORD = "password";
    private static final String NAME = "name";
    private static final String SURNAME = "surname";
    private static final String EMAIL = "email";
    private static final String ERROR_REGISTRATION = "registration.error";
    private static final String INVALID_FIELD = "invalid_field";

    @Override
    public CommandResult execute(HttpServletRequest request, HttpServletResponse response) throws CommandException {
        Map<String, String> parameters = new HashMap<>();
        parameters.put(LOGIN, request.getParameter(LOGIN));
        parameters.put(PASSWORD, request.getParameter(PASSWORD));
        parameters.put(NAME, request.getParameter(NAME));
        parameters.put(SURNAME, request.getParameter(SURNAME));
        parameters.put(EMAIL, request.getParameter(EMAIL));

        for (Map.Entry<String, String> entry : parameters.entrySet()) {
            if (entry.getValue() == null || entry.getValue().isEmpty()) {
                logger.log(Level.ERROR, "Invalid " + entry.getKey() + " was received");
                return failure(request, INVALID_FIELD);
            }
        }

        boolean userExist = false;
        try {
            userExist = checkIfUserExist(parameters.get(LOGIN));
        } catch (ServiceException e) {
            logger.log(Level.WARN, e.getMessage());
            return failure(request, e.getMessage());
        }
        if (userExist) {
            logger.log(Level.WARN, "user with such login and password already exist");
            return failure(request, ERROR_REGISTRATION);
        }
        try {
            createUser(parameters, request);
            logger.log(Level.INFO, "user registrated and authorized with login - " + parameters.get(LOGIN));
            return new CommandResult(ResourceManager.getProperty("command.home"), true);
        } catch (ValidatorException | ServiceException e) {
            logger.log(Level.WARN, e.getMessage());
            return failure(request, e.getMessage());
        }


    }

    private boolean checkIfUserExist(String login) throws ServiceException {
        UserService service = new UserServiceImpl();
        return service.isExist(login);
    }

    private void createUser(Map<String, String> parameters, HttpServletRequest request) throws ServiceException, ValidatorException {
        User user = new User();
        user.setLogin(parameters.get(LOGIN));
        user.setPassword(parameters.get(PASSWORD));
        user.setPermission(new Value(BasePermission.USER));

        UserInfo info = new UserInfo();
        info.setUser(user);
        info.setName(parameters.get(NAME));
        info.setSurname(parameters.get(SURNAME));
        info.setEmail(parameters.get(EMAIL));
        info.setDateOfRegistration(new Date());
        info.setDateOfBirth(new Date());

        if (userValid(user) && infoValid(info)) {
            UserService userService = new UserServiceImpl();
            Integer id = userService.save(user);
            if (id != null) {
                user.setId(id);

                UserInfoService infoService = new UserInfoServiceImpl();
                infoService.save(info);
            } else {
                throw new ServiceException("Can't save user!");
            }
        }

        UserDto userDto = new UserDto(user);
        request.getSession().setAttribute(USER.getFieldName(), userDto);
        setMenuForUser(user, request);
    }

    private boolean userValid(User user) throws ValidatorException {
        Validator validator = new UserValidator();
        String error = validator.isValid(user);
        if (error != null) {
            throw new ValidatorException(error);
        } else {
            return true;
        }
    }

    private boolean infoValid(UserInfo info) throws ValidatorException {
        Validator validator = new UserInfoValidator();
        String error = validator.isValid(info);
        if (error != null) {
            throw new ValidatorException(error);
        } else {
            return true;
        }
    }

    private void setMenuForUser(User user, HttpServletRequest request) {
        Menu menu = MenuFactory.getMenu(user.getPermission());
        request.getSession().setAttribute("menu", menu.getMenuItems());
    }

    private CommandResult failure(HttpServletRequest request, String error) {
        request.getSession().setAttribute(ERROR, error);
        return new CommandResult(ResourceManager.getProperty("command.registerPage"), true);
    }
}
