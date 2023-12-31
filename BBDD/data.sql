-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema javaschool
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `javaschool` DEFAULT CHARACTER SET utf8mb4 ;
USE `javaschool`;

-- -----------------------------------------------------
-- Table `javaschool`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `javaschool`.`client` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `surname` VARCHAR(45) NULL,
  `date_of_birth` DATE NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(100) NULL,
  `role` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `javaschool`.`clients_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `javaschool`.`clients_address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `postal_code` VARCHAR(45) NULL,
  `street` VARCHAR(45) NULL,
  `home` VARCHAR(45) NULL,
  `apartment` VARCHAR(45) NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_clients_address_client_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_clients_address_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `javaschool`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `javaschool`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `javaschool`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `payment_method` VARCHAR(45) NULL,
  `delivery_method` VARCHAR(45) NULL,
  `payment_status` VARCHAR(45) NULL,
  `order_status` VARCHAR(45) NULL,
  `order_date` DATE NULL,
  `client_id` INT NOT NULL,
  `clients_address_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_orders_clients_address_idx` (`clients_address_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `javaschool`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_clients_address`
    FOREIGN KEY (`clients_address_id`)
    REFERENCES `javaschool`.`clients_address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `javaschool`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `javaschool`.`product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NULL,
  `price` DECIMAL(10,2) NULL,
  `category` VARCHAR(45) NULL,
  `parameters` VARCHAR(45) NULL,
  `weight` DECIMAL(10,2) NULL,
  `volume` DECIMAL(10,2) NULL,
  `quantity_stock` INTEGER NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `javaschool`.`order_has_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `javaschool`.`order_has_product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `orders_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_has_product_product_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_order_has_product_orders_idx` (`orders_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_has_product_orders`
    FOREIGN KEY (`orders_id`)
    REFERENCES `javaschool`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_has_product_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `javaschool`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `javaschool`.`refresh_token`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `javaschool`.`refresh_token` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `token` VARCHAR(255) NOT NULL,
  `expiration` DATETIME NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_refresh_token_client_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_refresh_token_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `javaschool`.`client` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;




INSERT INTO `javaschool`.`client` (`name`, `surname`, `date_of_birth`, `email`, `password`, `role`)
VALUES
    ('Diego', 'Martín', '1999-07-31', 'diego@example.com', 'password123', 'ROLE_ADMIN'),
    ('María', 'Jimenez', '1985-03-20', 'maria@example.com', 'password321', 'ROLE_USER'),
    ('Juan', 'García', '1995-07-10', 'pedro@example.com', 'password456', 'ROLE_USER');

INSERT INTO `javaschool`.`clients_address` (`country`, `city`, `postal_code`, `street`, `home`, `apartment`, `client_id`)
VALUES
	('Spain', 'Madrid', '28001', 'Calle de Serrano', 'apartment','45B', 1),
    ('United States', 'New York', '10001', 'Main Street', 'apartment','123A', 2),
    ('France', 'Paris', '75008', 'Champs-Élysées', 'house','578', 3);

INSERT INTO `javaschool`.`orders` (`payment_method`, `delivery_method`, `payment_status`, `order_status`, `order_date`, `client_id`, `clients_address_id`)
VALUES
	('Credit Card', 'Express Shipping', 'Paid', 'Processing', '1995-07-10', 1, 2);


INSERT INTO `javaschool`.`product` (`title`, `price`, `category`, `parameters`, `weight`, `volume`, `quantity_stock`, `image`)
VALUES
    ('MIDI Piano', 200, 'Musical Instruments', 'Type: MIDI, Color: Silver', 15, 0, 5, 'photo1.jpg'),
    ('Modern Desk Lamp', 50, 'Home & Living', 'Power Source: Electric', 1, 0, 20, 'photo2.jpg'),
    ('Rolex', 10000, 'Fashion', 'Material: Stainless Steel', 0, 0, 10, 'photo3.jpg');


INSERT INTO `javaschool`.`order_has_product` (`orders_id`, `product_id`, `quantity`)
VALUES
    (1, 1, 3);


SELECT * FROM javaschool.client;
SELECT * FROM javaschool.clients_address;
SELECT * FROM javaschool.orders;
SELECT * FROM javaschool.product;
SELECT * FROM javaschool.order_has_product;
SELECT * FROM javaschool.refresh_token;

ALTER TABLE product
DROP COLUMN image;

-- SELECT p.*, SUM(ohp.quantity) as total 
-- FROM Product p 
-- JOIN order_has_product ohp ON p.id = ohp.product_id 
-- GROUP BY p.id 
-- ORDER BY SUM(ohp.quantity) DESC
-- LIMIT 10;

-- SELECT c, SUM(ohp.quantity) as totalQuantity " +
-- "FROM Client c " +
-- "JOIN c.orders o " +
-- "JOIN OrderHasProduct ohp ON o.id = ohp.orders.id " +
-- "GROUP BY c " +
-- "ORDER BY SUM(ohp.quantity) DESC

-- SELECT SUM(p.price) as monthlyEarnings
-- FROM javaschool.orders o
-- JOIN javaschool.order_has_product ohp ON o.id = ohp.orders_id
-- JOIN javaschool.product p ON ohp.product_id = p.id
-- WHERE YEAR(o.order_date) = 2023
-- AND MONTH(o.order_date) = 10;


-- SELECT SUM(p.price) as weeklyEarnings
-- FROM javaschool.orders o
-- JOIN javaschool.order_has_product ohp ON o.id = ohp.orders_id
-- JOIN javaschool.product p ON ohp.product_id = p.id
-- WHERE YEARWEEK(o.order_date) = YEARWEEK(CURRENT_DATE());


-- USE javaschool;
-- SELECT ohp.product_id
-- FROM order_has_product ohp
-- JOIN orders o ON ohp.orders_id = o.id
-- WHERE o.client_id = 39;

-- ALTER TABLE `javaschool`.`product`
-- ADD COLUMN `image` TEXT NULL;

-- ALTER TABLE product
-- DROP COLUMN image;

-- ALTER TABLE product MODIFY COLUMN image LONGBLOB;




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
