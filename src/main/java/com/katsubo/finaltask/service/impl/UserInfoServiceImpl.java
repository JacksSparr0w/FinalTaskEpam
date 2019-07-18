package com.katsubo.finaltask.service.impl;

import com.katsubo.finaltask.dao.DaoException;
import com.katsubo.finaltask.dao.UserInfoDao;
import com.katsubo.finaltask.dao.impl.UserInfoDaoImpl;
import com.katsubo.finaltask.entity.User;
import com.katsubo.finaltask.entity.UserInfo;
import com.katsubo.finaltask.service.ServiceException;
import com.katsubo.finaltask.service.UserInfoService;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class UserInfoServiceImpl extends ServiceImpl implements UserInfoService {
    private static final Logger logger = LogManager.getLogger(UserInfoServiceImpl.class);

    @Override
    public UserInfo findByUser(User user) throws ServiceException {
        if (user != null) {
            UserInfo info = null;
            UserInfoDao dao = transaction.getUserInfoDao();
            try {
                info = dao.read(user);
            } catch (DaoException e) {
                throw new ServiceException(e);
            }
            return info;
        } else {
            logger.log(Level.ERROR, "Parameter - USER is invalid");
            throw new ServiceException("Parameter - USER is invalid");
        }
    }

    @Override
    public void save(UserInfo userInfo) throws ServiceException {
        if (userInfo != null) {
            UserInfoDao dao = transaction.getUserInfoDao();
            try {
                if (userInfo.getId() != null) {
                    dao.update(userInfo);
                } else {
                    dao.create(userInfo);
                }
            } catch (DaoException e) {
                throw new ServiceException(e);
            }
        } else {
            logger.log(Level.ERROR, "Parameter - USER_INFO is invalid");
            throw new ServiceException("Parameter - USER_INFO is invalid");
        }
    }

    @Override
    public void delete(Integer id) throws ServiceException {
        if (id >= 0) {
            UserInfoDao dao = transaction.getUserInfoDao();
            try {
                dao.delete(id);
            } catch (DaoException e) {
                throw new ServiceException(e);
            }
        } else {
            logger.log(Level.ERROR, "Parameter - ID is inalid");
            throw new ServiceException("Parameter - ID is invalid");
        }
    }
}
