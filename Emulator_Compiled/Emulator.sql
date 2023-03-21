CREATE TABLE `users_subscriptions` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NULL,
  `subscription_type` varchar(255) NULL,
  `timestamp_start` int(10) UNSIGNED NULL,
  `duration` int(10) UNSIGNED NULL,
  `active`  tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `user_id`(`user_id`),
  INDEX `subscription_type`(`subscription_type`),
  INDEX `timestamp_start`(`timestamp_start`),
  INDEX `active`(`active`)
);

CREATE TABLE `logs_shop_purchases` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `timestamp` int(10) UNSIGNED NULL,
  `user_id` int(10) UNSIGNED NULL,
  `catalog_item_id` int(10) UNSIGNED NULL,
  `item_ids` text DEFAULT NULL,
  `catalog_name` varchar(255) NULL,
  `cost_credits` int(10) NULL,
  `cost_points` int(10) NULL,
  `points_type` int(10) NULL,
  `amount` int(10) NULL,
  PRIMARY KEY (`id`),
  INDEX `timestamp`(`timestamp`),
  INDEX `user_id`(`user_id`)
);

CREATE TABLE `logs_hc_payday` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `timestamp` int(10) UNSIGNED NULL,
  `user_id` int(10) UNSIGNED NULL,
  `hc_streak` int(10) UNSIGNED NULL,
  `total_coins_spent` int(10) UNSIGNED NULL,
  `reward_coins_spent` int(10) UNSIGNED NULL,
  `reward_streak` int(10) UNSIGNED NULL,
  `total_payout` int(10) UNSIGNED NULL,
  `currency` varchar(255) NULL,
  `claimed` tinyint(1) DEFAULT 0 NULL,
  PRIMARY KEY (`id`),
  INDEX `timestamp`(`timestamp`),
  INDEX `user_id`(`user_id`)
);

ALTER TABLE `emulator_settings` MODIFY COLUMN `value` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL AFTER `key`;
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.enabled', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.next_date', '2020-10-15 00:00:00');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.interval', '1 month');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.query', 'SELECT SUM(cost_credits) AS `amount_spent` FROM `logs_shop_purchases` WHERE `user_id` = @user_id AND `timestamp` > @timestamp_start AND `timestamp` <= @timestamp_end AND `catalog_name` NOT LIKE \'CF_%\' AND `catalog_name` NOT LIKE \'CFC_%\';');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.streak', '7=5;30=10;60=15;90=20;180=25;365=30');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.currency', 'credits');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.percentage', '10');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.payday.creditsspent_reset_on_expire', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.achievement', 'VipHC');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.discount.enabled', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.hc.discount.days_before_end', '7');

INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.scheduler.enabled', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('subscriptions.scheduler.interval', '10');

INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.clothingvalidation.onhcexpired', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.clothingvalidation.onlogin', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.clothingvalidation.onchangelooks', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.clothingvalidation.onmimic', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.clothingvalidation.onmannequin', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.clothingvalidation.onfballgate', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('gamedata.figuredata.url', 'https://habbo.com/gamedata/figuredata/0');

INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.max.friends', '300');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.max.friends.hc', '1100');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.max.rooms', '50');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.users.max.rooms.hc', '75');

INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.auto.pixels.hc_modifier', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.auto.points.hc_modifier', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.auto.credits.hc_modifier', '1');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('hotel.auto.gotwpoints.hc_modifier', '1');

INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('room.chat.mutearea.allow_whisper', '1');

DELETE FROM `emulator_settings` WHERE `key` IN ('hotel.max.rooms.per.user', 'hotel.max.rooms.user', 'hotel.max.rooms.vip', 'max.friends', 'hotel.max.friends', 'max.friends.hc', 'hotel.max.friends.hc');

ALTER TABLE `users_settings` ADD COLUMN `max_friends` int(10) NULL DEFAULT 300 AFTER `has_gotten_default_saved_searches`;
ALTER TABLE `users_settings` ADD COLUMN `max_rooms` int(10) NULL DEFAULT 50 AFTER `has_gotten_default_saved_searches`;
ALTER TABLE `users_settings` ADD COLUMN `last_hc_payday` int(10) NULL DEFAULT 0 AFTER `has_gotten_default_saved_searches`;
ALTER TABLE `users_settings` ADD COLUMN `hc_gifts_claimed` int(10) NULL DEFAULT 0 AFTER `has_gotten_default_saved_searches`;

ALTER TABLE `permissions` ADD COLUMN `cmd_subscription` enum('0','1') NULL DEFAULT '0' AFTER `cmd_credits`;
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.keys.cmd_subscription', 'subscription;sub');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.invalid_action', 'Invalid action specified. Must be add, +, remove or -');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.type_not_found', '%subscription% is not a valid subscription type');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.invalid_params_time', 'Invalid time span, try: x minutes/days/weeks/months');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.success_add_time', 'Successfully added %time% seconds to %subscription% on %user%');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.user_not_have', '%user% does not have the %subscription% subscription');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.success_remove_time', 'Successfully removed %time% seconds from %subscription% on %user%');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.success_remove_sub', 'Successfully removed %subscription% sub from %user%');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.user_not_found', '%user% was not found');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_subscription.invalid_params', 'Invalid command format');

INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('subscriptions.hc.payday.message', 'Woohoo HC Payday has arrived! You have received %amount% credits to your purse. Enjoy!');

INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('hotel.roomuser.idle.not_dancing.ignore.wired_idle', '0');

-- OPTIONAL HC MIGRATION
-- INSERT INTO users_subscriptions SELECT NULL, user_id, 'HABBO_CLUB' as `subscription_type`, UNIX_TIMESTAMP() AS `timestamp_start`, (club_expire_timestamp - UNIX_TIMESTAMP()) AS `duration`, 1 AS `active` FROM users_settings WHERE club_expire_timestamp > UNIX_TIMESTAMP();

INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('hotel.rooms.deco_hosting', '1');

INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('easter_eggs.enabled', '1');

ALTER TABLE `bots`
ADD COLUMN `bubble_id`  int(3) NULL DEFAULT 31 AFTER `effect`;

-- Permissions to see tent chat
ALTER TABLE `permissions` ADD `acc_see_tentchat` ENUM('0', '1') NOT NULL DEFAULT '0' AFTER `acc_see_whispers`;
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('hotel.room.tent.prefix', 'Tent');

-- Roombadge command
ALTER TABLE `permissions` ADD `cmd_roombadge` ENUM('0', '1') NOT NULL DEFAULT '0' AFTER `cmd_massbadge`;
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_roombadge.no_badge', 'No badge specified!');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.keys.cmd_roombadge', 'roombadge');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.description.cmd_roombadge', ':roombadge <badge>');

-- Making items.wired_data column bigger since wired data is saved as JSON now
ALTER TABLE `items` MODIFY COLUMN `wired_data` varchar(10000);

-- Mute area sqls
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('room.chat.mutearea.allow_whisper', 'false');

INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('wired.place.under', '0');
INSERT INTO `emulator_settings`(`key`, `value`) VALUES ('wired.custom.enabled', '0');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.error.cmd_stalk.forgot_username', 'Specify the username of the Habbo you want to follow!');

INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('console.mode', '0');

INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('youtube.apikey', '');
INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('hotel.gifts.length.max', '300');
CREATE TABLE `messenger_categories` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(25) NOT NULL,
    `user_id` int NOT NULL,
    UNIQUE KEY `identifier` (`id`)
);
ALTER TABLE messenger_friendships ADD category int NOT NULL DEFAULT '0' AFTER friends_since;
DROP TABLE IF EXISTS `calendar_campaigns`;
CREATE TABLE `calendar_campaigns` (
                                      `id` int NOT NULL AUTO_INCREMENT,
                                      `name` varchar(255) NOT NULL DEFAULT '',
                                      `image` varchar(255) NOT NULL DEFAULT '',
                                      `start_timestamp` int NOT NULL DEFAULT '0',
                                      `total_days` int NOT NULL DEFAULT '30',
                                      `lock_expired` enum('1','0') NOT NULL DEFAULT '1',
                                      `enabled` enum('1','0') NOT NULL DEFAULT '1',
                                      UNIQUE KEY `id` (`id`)
);
DROP TABLE IF EXISTS `calendar_rewards`;
CREATE TABLE `calendar_rewards` (
                                    `id` int NOT NULL AUTO_INCREMENT,
                                    `campaign_id` int NOT NULL DEFAULT '0',
                                    `product_name` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
                                    `custom_image` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
                                    `credits` int NOT NULL DEFAULT '0',
                                    `pixels` int NOT NULL DEFAULT '0',
                                    `points` int NOT NULL DEFAULT '0',
                                    `points_type` int NOT NULL DEFAULT '0',
                                    `badge` varchar(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
                                    `item_id` int NOT NULL DEFAULT '0',
                                    `subscription_type` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '',
                                    `subscription_days` int NOT NULL DEFAULT '0',
                                    PRIMARY KEY (`id`) USING BTREE
);
DROP TABLE IF EXISTS `calendar_rewards_claimed`;
CREATE TABLE `calendar_rewards_claimed` (
                                            `user_id` int NOT NULL,
                                            `campaign_id` int NOT NULL DEFAULT '0',
                                            `day` int NOT NULL,
                                            `reward_id` int NOT NULL,
                                            `timestamp` int NOT NULL
);
INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('hotel.calendar.default', 'test');
INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('hotel.calendar.pixels.hc_modifier', '2.0');
ALTER TABLE `permissions` ADD COLUMN `acc_calendar_force` enum('0','1') NULL DEFAULT '0';
ALTER TABLE `permissions` ADD `cmd_update_calendar` ENUM('0', '1') NOT NULL DEFAULT '0';
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.description.cmd_update_calendar', ':update_calendar'), ('commands.keys.cmd_update_calendar', 'update_calendar');
INSERT INTO `emulator_texts` (`key`, `value`) VALUES ('commands.success.cmd_update_calendar', 'Calendar updated successfully!');
INSERT INTO `emulator_settings` (`key`, `value`) VALUES ('moodlight.color_check.enabled', '1');
exit

