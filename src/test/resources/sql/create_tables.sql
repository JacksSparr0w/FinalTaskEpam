USE `test`;

CREATE TABLE `user`
(
  `id`         INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `login`      VARCHAR(255) UNIQUE NOT NULL,
  `password`   VARCHAR(32)         NOT NULL,
  `permission` ENUM ('administrator', 'user') DEFAULT 'user'
) ENGINE = INNODB
  DEFAULT CHARACTER SET utf8;

CREATE TABLE `user_info`
(
  `id`                   INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id`              INTEGER UNIQUE      NOT NULL,
  `name`                 VARCHAR(255)        NOT NULL,
  `surname`              VARCHAR(255)        NOT NULL,
  `about`                TEXT,
  `picture_link`         VARCHAR(255) DEFAULT NULL,
  `email`                VARCHAR(255)        NOT NULL,
  `date_of_birth`        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `date_of_registration` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB
  DEFAULT CHARACTER SET utf8;


CREATE TABLE `event_info`
(
  `id`           INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name`         VARCHAR(255)        NOT NULL,
  `description`  TEXT,
  `picture_link` VARCHAR(255)                                          DEFAULT NULL,
  `theme`        ENUM ('business', 'advertising', 'science', 'design') DEFAULT NULL,
  `date`         TIMESTAMP           NOT NULL,
  `address`      VARCHAR(255),
  `author_id`    INTEGER             NOT NULL,
  `capacity`     INTEGER
) ENGINE = INNODB
  DEFAULT CHARACTER SET utf8;

CREATE TABLE `registrations`
(
  `id`        INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `event_id`  INTEGER,
  `user_id`   INTEGER,
  `user_role` ENUM ('listener', 'teller', 'author') DEFAULT 'listener'
) ENGINE = INNODB
  DEFAULT CHARACTER SET utf8;

ALTER TABLE `user_info`
  ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE `registrations`
  ADD FOREIGN KEY (`event_id`) REFERENCES `event_info` (`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE `registrations`
  ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE `event_info`
  ADD FOREIGN KEY (`author_id`) REFERENCES `user` (`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE;