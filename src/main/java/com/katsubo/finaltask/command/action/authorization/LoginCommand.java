package com.katsubo.finaltask.command.action.authorization;

import com.katsubo.finaltask.command.CommandException;
import com.katsubo.finaltask.command.CommandResult;
import com.katsubo.finaltask.command.action.Command;
import com.katsubo.finaltask.entity.Permission;
import com.katsubo.finaltask.entity.User;
import com.katsubo.finaltask.entity.UserDto;
import com.katsubo.finaltask.filter.AccessSystem;
import com.katsubo.finaltask.service.PermissionService;
import com.katsubo.finaltask.service.ServiceException;
import com.katsubo.finaltask.service.UserService;
import com.katsubo.finaltask.service.impl.PermissionServiceImpl;
import com.katsubo.finaltask.service.impl.UserServiceImpl;
import com.katsubo.finaltask.util.ResourceManager;
import com.katsubo.finaltask.util.menu.MenuCreator;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static com.katsubo.finaltask.util.Constances.USER;

/**
 * The type Login command.
 */
public class LoginCommand implements Command {
    private static final Logger logger = LogManager.getLogger(LoginCommand.class);
    private static final String LOGIN = "login";
    private static final String PASSWORD = "password";
    private static final String ERROR_LOGIN = "error_login";
    private static final String ERROR_PASSWORD = "error_password";
    private static final String ERROR_AUTHENTIFICATION = "authorization.error";
    private static final String ERROR = "error";

    @Override
    public CommandResult execute(HttpServletRequest request, HttpServletResponse response) throws CommandException {
        String login = request.getParameter(LOGIN);
        String password = request.getParameter(PASSWORD);
        if (login == null || login.isEmpty()) {
            logger.log(Level.WARN, "invalid login was received");
            return failure(request, ERROR_LOGIN);
        }
        if (password == null || password.isEmpty()) {
            return failure(request, ERROR_PASSWORD);
        }
        boolean userExist = false;
        try {
            userExist = initializeUser(login, password, request);
        } catch (ServiceException e) {
            logger.log(Level.WARN, e.getMessage());
            return failure(request, e.getMessage());
        }
        if (userExist) {

            logger.log(Level.WARN, "user authorized with login - " + login);
            return new CommandResult(ResourceManager.getProperty("command.home"), true);
        } else {
            logger.log(Level.WARN, "user with such login and password doesn't exist");
            return failure(request, ERROR_AUTHENTIFICATION);
        }


    }

    private boolean initializeUser(String login, String password, HttpServletRequest request) throws ServiceException {
        UserService service = new UserServiceImpl();
        User user = service.findByLoginAndPassword(login, password);
        if (user != null && user.getId() != null) {
            setAttributesToSession(request, user);
            return true;
        } else {
            return false;
        }
    }

    private void setAttributesToSession(HttpServletRequest request, User user) {
        UserDto userDto = new UserDto(user);
        request.getSession().setAttribute(USER.getFieldName(), userDto);
        Permission permission = null;
        try {
            PermissionService service = new PermissionServiceImpl();
            permission = service.findAll(user.getPermissionId());
            request.getSession().setAttribute("permission", permission);
        } catch (ServiceException e) {
            logger.log(Level.WARN, "cant findAll permission, set default");
            //todo
        }
        request.getSession().setAttribute("menu", MenuCreator.getMenuItems(permission));
        AccessSystem.updateRules(userDto);
    }

    private CommandResult failure(HttpServletRequest request, String error) {
        request.getSession().setAttribute(ERROR, error);
        return new CommandResult(ResourceManager.getProperty("command.loginPage"), true);
    }
}
