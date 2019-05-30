/*
 Navicat Premium Data Transfer

 Source Server         : 本地测试库
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : weibo

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 30/05/2019 22:45:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '作者id',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `cover` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '封面',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `like` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `comment` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
  `share` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '转发数',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `collect` int(10) UNSIGNED NOT NULL COMMENT '收藏量',
  `status` smallint(1) UNSIGNED NOT NULL COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_user_id_5` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for chat
-- ----------------------------
DROP TABLE IF EXISTS `chat`;
CREATE TABLE `chat`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(70) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '聊天唯一编号',
  `owner_id` bigint(10) UNSIGNED NOT NULL COMMENT '群主id',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'friend' COMMENT '聊天类型',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '群聊' COMMENT '聊天名称',
  `photo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'chat.png' COMMENT '聊天头像',
  `member` smallint(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '成员人数',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_owner_id`(`owner_id`) USING BTREE,
  CONSTRAINT `fk_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 255 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat
-- ----------------------------
INSERT INTO `chat` VALUES (254, '64feb1c4cb08425787f971d08e9632da', 0, 'friend', '群聊', 'chat.png', 2, 0, '2019-05-30 22:42:26', '2019-05-30 22:42:26');

-- ----------------------------
-- Table structure for friend
-- ----------------------------
DROP TABLE IF EXISTS `friend`;
CREATE TABLE `friend`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '用户id',
  `friend_id` bigint(10) UNSIGNED NOT NULL COMMENT '好友id',
  `chat_id` bigint(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '聊天id',
  `photo` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'default_head' COMMENT '好友头像',
  `group_id` bigint(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所处分组id',
  `alias` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '好友备注',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '未添加好友描述' COMMENT '好友描述',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_2`(`user_id`) USING BTREE,
  INDEX `fk_friend_id_1`(`friend_id`) USING BTREE,
  INDEX `fk_group_id_1`(`group_id`) USING BTREE,
  CONSTRAINT `fk_friend_id_1` FOREIGN KEY (`friend_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_group_id_1` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of friend
-- ----------------------------
INSERT INTO `friend` VALUES (22, 0, 1, 254, 'default_head', 0, '', '我是微博团队,我关注了你！', 0, '2019-05-30 22:41:50', '2019-05-30 22:41:50');
INSERT INTO `friend` VALUES (23, 1, 0, 254, 'default_head', 0, '', '我是用户1,我关注了你！', 0, '2019-05-30 22:42:25', '2019-05-30 22:42:25');

-- ----------------------------
-- Table structure for group
-- ----------------------------
DROP TABLE IF EXISTS `group`;
CREATE TABLE `group`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT ' ',
  `user_id` bigint(10) NOT NULL COMMENT '用户id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分组名称',
  `priority` smallint(10) UNSIGNED NOT NULL COMMENT '优先级',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group
-- ----------------------------
INSERT INTO `group` VALUES (0, 0, '默认分组', 0, 0, '2019-05-09 16:30:16', '2019-05-23 19:59:08');

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '用户id',
  `chat_id` bigint(10) UNSIGNED NOT NULL COMMENT '角色id',
  `group_alias` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '群聊昵称',
  `apply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '大家好，我是本群的新成员' COMMENT '加群申请',
  `level` smallint(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '群等级',
  `background` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '聊天背景',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id`(`user_id`) USING BTREE,
  INDEX `fk_role_id`(`chat_id`) USING BTREE,
  CONSTRAINT `fk_chat_id_2` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id_6` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 848 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member
-- ----------------------------
INSERT INTO `member` VALUES (846, 1, 254, '用户1', '大家好，我是本群的新成员', 0, '', 0, '2019-05-30 22:42:26', '2019-05-30 22:42:26');
INSERT INTO `member` VALUES (847, 0, 254, '微博团队', '大家好，我是本群的新成员', 0, '', 0, '2019-05-30 22:42:26', '2019-05-30 22:42:26');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sender_id` bigint(10) UNSIGNED NOT NULL COMMENT '发送者id',
  `chat_id` bigint(10) UNSIGNED NOT NULL COMMENT '聊天id',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '消息内容',
  `type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '消息类型',
  `time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '发送时间',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_3`(`sender_id`) USING BTREE,
  INDEX `fk_chat_id_4`(`chat_id`) USING BTREE,
  CONSTRAINT `fk_chat_id_4` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id_3` FOREIGN KEY (`sender_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 816 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES (813, 1, 254, '我们达成了双向关注关系，现在我们可以开始聊天了', 'user', '2019-05-30 22:42:26.051000', 0, '2019-05-30 22:42:26', '2019-05-30 22:42:26');
INSERT INTO `message` VALUES (814, 1, 254, '<img src=\"/weibo/upload/file/c746b5b249404e52a1e4c8192917a96b.jpg\"\n         style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', 'img', '2019-05-30 22:42:47.779000', 0, '2019-05-30 22:42:47', '2019-05-30 22:42:47');
INSERT INTO `message` VALUES (815, 1, 254, '[文件：微信图片_20190518151203.jpg]<a href=\"http://localhost:8080/weibo/upload/file/539ce0a47093426b8bcaa36ce79d92ac.jpg\" download=\"微信图片_20190518151203.jpg\">下载</a>', 'file', '2019-05-30 22:42:58.752000', 0, '2019-05-30 22:42:58', '2019-05-30 22:42:58');

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '发布者id',
  `tweet_id` bigint(10) UNSIGNED NOT NULL COMMENT '微博id',
  `loved` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否点赞',
  `shared` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否转发',
  `viewed` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否浏览',
  `collected` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否收藏',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_4`(`user_id`) USING BTREE,
  INDEX `fk_moment_id_3`(`tweet_id`) USING BTREE,
  CONSTRAINT `fk_tweet_id_3` FOREIGN KEY (`tweet_id`) REFERENCES `tweet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id_12` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 253 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of news
-- ----------------------------
INSERT INTO `news` VALUES (87, 0, 88, 1, 0, 0, 0, 0, '2019-05-09 15:56:57', '2019-05-09 15:56:57');
INSERT INTO `news` VALUES (89, 0, 92, 0, 0, 0, 0, 0, '2019-05-09 23:52:25', '2019-05-09 23:52:25');
INSERT INTO `news` VALUES (92, 0, 94, 0, 0, 0, 0, 0, '2019-05-10 01:15:55', '2019-05-10 01:15:55');
INSERT INTO `news` VALUES (94, 0, 95, 0, 0, 0, 0, 0, '2019-05-10 01:16:25', '2019-05-10 01:16:25');
INSERT INTO `news` VALUES (96, 0, 96, 0, 0, 0, 0, 0, '2019-05-10 07:15:45', '2019-05-10 07:15:45');
INSERT INTO `news` VALUES (134, 0, 103, 0, 0, 0, 0, 0, '2019-05-15 04:05:51', '2019-05-15 04:05:51');
INSERT INTO `news` VALUES (157, 0, 104, 0, 0, 0, 0, 0, '2019-05-15 04:05:59', '2019-05-15 04:05:59');
INSERT INTO `news` VALUES (180, 0, 105, 1, 0, 0, 0, 0, '2019-05-15 04:06:04', '2019-05-15 04:06:04');
INSERT INTO `news` VALUES (203, 0, 106, 0, 0, 0, 0, 0, '2019-05-15 04:06:08', '2019-05-15 04:06:08');
INSERT INTO `news` VALUES (226, 0, 107, 0, 0, 0, 0, 0, '2019-05-15 04:06:12', '2019-05-15 04:06:12');
INSERT INTO `news` VALUES (249, 0, 108, 0, 0, 0, 0, 0, '2019-05-15 04:06:48', '2019-05-15 04:06:48');
INSERT INTO `news` VALUES (250, 0, 212, 0, 0, 0, 0, 0, '2019-05-27 21:21:27', '2019-05-27 21:21:27');
INSERT INTO `news` VALUES (251, 0, 210, 1, 0, 0, 0, 0, '2019-05-28 23:23:46', '2019-05-28 23:23:46');
INSERT INTO `news` VALUES (252, 6, 216, 1, 0, 0, 0, 0, '2019-05-29 00:37:01', '2019-05-29 00:37:01');

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '权限名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '权限描述',
  `status` smallint(1) UNSIGNED NOT NULL COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for record
-- ----------------------------
DROP TABLE IF EXISTS `record`;
CREATE TABLE `record`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '用户id',
  `message_id` bigint(10) UNSIGNED NOT NULL COMMENT '消息id',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态（0未读，1已读）',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_3`(`user_id`) USING BTREE,
  INDEX `fk_message_id_2`(`message_id`) USING BTREE,
  CONSTRAINT `fk_message_id_2` FOREIGN KEY (`message_id`) REFERENCES `message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `record_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 19709 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of record
-- ----------------------------
INSERT INTO `record` VALUES (19703, 1, 813, 1, '2019-05-30 22:42:26', '2019-05-30 22:42:38');
INSERT INTO `record` VALUES (19704, 0, 813, 0, '2019-05-30 22:42:26', '2019-05-30 22:42:26');
INSERT INTO `record` VALUES (19705, 1, 814, 0, '2019-05-30 22:42:47', '2019-05-30 22:42:47');
INSERT INTO `record` VALUES (19706, 0, 814, 0, '2019-05-30 22:42:47', '2019-05-30 22:42:47');
INSERT INTO `record` VALUES (19707, 1, 815, 0, '2019-05-30 22:42:58', '2019-05-30 22:42:58');
INSERT INTO `record` VALUES (19708, 0, 815, 0, '2019-05-30 22:42:58', '2019-05-30 22:42:58');

-- ----------------------------
-- Table structure for remark
-- ----------------------------
DROP TABLE IF EXISTS `remark`;
CREATE TABLE `remark`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '评论者id',
  `tweet_id` bigint(10) UNSIGNED NOT NULL COMMENT '评论对象id',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '发表时间',
  `love` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `collect` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '收藏量',
  `reply` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '回复数',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_7`(`user_id`) USING BTREE,
  INDEX `fk_target_id_2`(`tweet_id`) USING BTREE,
  CONSTRAINT `fk_target_id_1` FOREIGN KEY (`tweet_id`) REFERENCES `tweet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id_7` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of remark
-- ----------------------------
INSERT INTO `remark` VALUES (3, 0, 88, '朋友圈的评论', '2019-05-14 10:28:54', 0, 0, 0, 0, '2019-05-14 02:04:54', '2019-05-14 02:04:54');
INSERT INTO `remark` VALUES (4, 0, 177, 'gg', '2019-05-25 02:03:39', 0, 0, 0, 0, '2019-05-25 02:03:39', '2019-05-25 02:03:39');
INSERT INTO `remark` VALUES (5, 0, 177, 'asd', '2019-05-25 02:05:01', 0, 0, 0, 0, '2019-05-25 02:05:01', '2019-05-25 02:05:01');
INSERT INTO `remark` VALUES (6, 0, 177, 'lll', '2019-05-25 08:45:28', 0, 0, 0, 0, '2019-05-25 08:45:29', '2019-05-25 08:45:29');
INSERT INTO `remark` VALUES (7, 0, 177, '@test@qq.com kk', '2019-05-25 08:45:51', 0, 0, 0, 0, '2019-05-25 08:45:51', '2019-05-25 08:45:51');
INSERT INTO `remark` VALUES (8, 0, 212, '一条评论', '2019-05-27 21:22:12', 0, 0, 0, 0, '2019-05-27 21:22:13', '2019-05-27 21:22:13');
INSERT INTO `remark` VALUES (9, 6, 216, '我的评论', '2019-05-29 00:14:19', 0, 0, 0, 0, '2019-05-29 00:14:19', '2019-05-29 00:14:19');
INSERT INTO `remark` VALUES (10, 6, 216, '@test2@qq.com 我的回复', '2019-05-29 00:14:32', 0, 0, 0, 0, '2019-05-29 00:14:33', '2019-05-29 00:14:33');

-- ----------------------------
-- Table structure for reply
-- ----------------------------
DROP TABLE IF EXISTS `reply`;
CREATE TABLE `reply`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '回复者id',
  `to_uid` bigint(10) UNSIGNED NOT NULL COMMENT '被回复用户id',
  `remark_id` bigint(10) UNSIGNED NOT NULL COMMENT '所处评论id',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `love` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `status` smallint(1) UNSIGNED NOT NULL COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_8`(`user_id`) USING BTREE,
  INDEX `fk_remark_id_1`(`remark_id`) USING BTREE,
  CONSTRAINT `fk_remark_id_1` FOREIGN KEY (`remark_id`) REFERENCES `remark` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id_8` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '角色描述',
  `status` smallint(1) UNSIGNED NOT NULL COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint(10) UNSIGNED NOT NULL COMMENT '角色id',
  `permission_id` bigint(10) UNSIGNED NOT NULL COMMENT '权限id',
  `status` smallint(1) UNSIGNED NOT NULL COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_permission_id`(`permission_id`) USING BTREE,
  INDEX `fk_permission_role`(`role_id`) USING BTREE,
  CONSTRAINT `fk_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permission_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '群聊' COMMENT '话题名称',
  `owner_id` bigint(10) UNSIGNED NOT NULL COMMENT '主持人id',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'friend' COMMENT '话题分类',
  `location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地区',
  `photo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'chat.png' COMMENT '话题头像',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_owner_id`(`owner_id`) USING BTREE,
  CONSTRAINT `topic_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tweet
-- ----------------------------
DROP TABLE IF EXISTS `tweet`;
CREATE TABLE `tweet`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `owner_id` bigint(10) UNSIGNED NOT NULL COMMENT '发布者id',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '内容',
  `origin_id` bigint(10) UNSIGNED NULL DEFAULT NULL COMMENT '被转发微博的id',
  `time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '发布时间',
  `love` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `remark` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
  `share` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '转发数',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `sort` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '其他' COMMENT '分类',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id_4`(`owner_id`) USING BTREE,
  CONSTRAINT `fk_user_id_4` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 235 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tweet
-- ----------------------------
INSERT INTO `tweet` VALUES (88, 0, 'com.hyc.wechat.dao.impl.DataSourceImpl.getConnection(DataSourceImpl.java:155)]连接池已创建连接数3空闲连接数2[INFO]-[com.hyc.wechat.controller.impl.filter.EncodingFilter.doFilter(EncodingFilter.java:77)][请求url]:/upload/photo/upload.jpg[请求参数]：null[INFO]-[com.hyc.wechat.controller.impl.filter.EncodingFilter.doFilter(EncodingFilter.java:77)][请求url]:/upload/photo/user.photo[请求参数]：null[INFO]-[com.hyc.wechat.controller.impl.filter.EncodingFilter.doFilter(EncodingFilter.java:77)][请求url]:/upload/photo/[请求参数]：nullcom.mysql.cj.jdbc.ClientPreparedStatement:selectm.id,m.sender_id,m.chat_id,m.content,m.type,m.time,m.status,m.gmt_create,m.gmt_modifiedfrommessageasm,recordasrwherem.id=r.message_idandr.user_id=\'209\'andr.status=0orderbym.timed', NULL, '2019-05-09 15:56:55', 1, 1, 0, 6, '体育', 0, '2019-05-09 15:56:55', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (92, 0, 'com.hyc.wechat.dao.impl.DataSourceImpl.getConnection(DataSourceImpl.java:155)]连接池已创建连接数3空闲连接数2[INFO]-[com.hyc.wechat.controller.impl.filter.EncodingFilter.doFilter(EncodingFilter.java:77)][请求url]:/upload/photo/upload.jpg[请求参数]：null[INFO]-[com.hyc.wechat.controller.impl.filter.EncodingFilter.doFilter(EncodingFilter.java:77)][请求url]:/upload/photo/user.photo[请求参数]：null[INFO]-[com.hyc.wechat.controller.impl.filter.EncodingFilter.doFilter(EncodingFilter.java:77)][请求url]:/upload/photo/[请求参数]：nullcom.mysql.cj.jdbc.ClientPreparedStatement:selectm.id,m.sender_id,m.chat_id,m.content,m.type,m.time,m.status,m.gmt_create,m.gmt_modifiedfrommessageasm,recordasrwherem.id=r.message_idandr.user_id=\'209\'andr.status=0orderbym.timed', NULL, '2019-05-09 23:52:24', 10, 2, 0, 16, '体育', 0, '2019-05-09 23:52:24', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (94, 0, '哈哈哈', NULL, '2019-05-10 01:15:54', 0, 0, 0, 16, '体育', 0, '2019-05-10 01:15:54', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (95, 0, '哈哈', NULL, '2019-05-10 01:16:24', 1, 0, 0, 16, '体育', 0, '2019-05-10 01:16:24', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (96, 0, '我要发朋友圈了', NULL, '2019-05-10 07:15:44', 0, 0, 0, 16, '体育', 0, '2019-05-10 07:15:44', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (97, 0, '一条朋友圈', NULL, '2019-05-13 18:38:39', 10, 0, 0, 6, '体育', 0, '2019-05-13 18:38:39', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (98, 0, '一条朋友圈', NULL, '2019-05-13 18:39:03', 10, 0, 0, 60, '体育', 0, '2019-05-13 18:39:03', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (103, 0, '第一条', NULL, '2019-05-15 04:05:51', 0, 0, 0, 75, '体育', 0, '2019-05-15 04:05:51', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (104, 0, '第二条', NULL, '2019-05-15 04:05:59', 0, 0, 0, 83, '体育', 0, '2019-05-15 04:05:59', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (105, 0, '第三条', NULL, '2019-05-15 04:06:04', 1, 0, 0, 83, '体育', 0, '2019-05-15 04:06:04', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (106, 0, '第四条', NULL, '2019-05-15 04:06:08', 0, 0, 0, 74, '体育', 0, '2019-05-15 04:06:08', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (107, 0, '第五条', NULL, '2019-05-15 04:06:12', 0, 0, 0, 74, '体育', 0, '2019-05-15 04:06:12', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (108, 0, '第六条', NULL, '2019-05-15 04:06:48', 1, 0, 0, 75, '体育', 0, '2019-05-15 04:06:48', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (129, 0, 'zzz', NULL, '2019-05-23 15:13:49', 0, 0, 0, 80, '体育', 1, '2019-05-23 15:13:49', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (130, 0, 'zzz', NULL, '2019-05-23 15:23:02', 0, 0, 0, 80, '体育', 1, '2019-05-23 15:23:02', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (131, 0, 'zzz', NULL, '2019-05-23 15:24:58', 0, 0, 0, 80, '体育', 1, '2019-05-23 15:24:58', '2019-05-23 19:53:40');
INSERT INTO `tweet` VALUES (133, 0, ';k;k;', NULL, '2019-05-24 00:27:47', 0, 0, 0, 20, '其他', 1, '2019-05-24 00:27:47', '2019-05-24 00:27:47');
INSERT INTO `tweet` VALUES (134, 0, 'xz', NULL, '2019-05-24 08:29:48', 0, 0, 0, 16, '其他', 1, '2019-05-24 08:29:48', '2019-05-24 08:29:48');
INSERT INTO `tweet` VALUES (135, 0, 'yitaio', NULL, '2019-05-24 15:51:01', 0, 0, 0, 18, '其他', 1, '2019-05-24 15:51:01', '2019-05-24 15:51:01');
INSERT INTO `tweet` VALUES (136, 0, 's', NULL, '2019-05-24 15:51:17', 0, 0, 0, 18, '其他', 1, '2019-05-24 15:51:17', '2019-05-24 15:51:17');
INSERT INTO `tweet` VALUES (137, 0, 'zzz', NULL, '2019-05-24 15:54:32', 0, 0, 0, 17, '其他', 1, '2019-05-24 15:54:32', '2019-05-24 15:54:32');
INSERT INTO `tweet` VALUES (138, 0, 'zzz', NULL, '2019-05-24 15:54:36', 0, 0, 0, 18, '其他', 1, '2019-05-24 15:54:36', '2019-05-24 15:54:36');
INSERT INTO `tweet` VALUES (139, 0, 'aa', NULL, '2019-05-24 16:09:36', 0, 0, 0, 17, '其他', 1, '2019-05-24 16:09:36', '2019-05-24 16:09:36');
INSERT INTO `tweet` VALUES (140, 0, '看看', NULL, '2019-05-24 23:39:36', 0, 0, 0, 13, '其他', 1, '2019-05-24 23:39:36', '2019-05-24 23:39:36');
INSERT INTO `tweet` VALUES (141, 0, '在这种 ', NULL, '2019-05-24 23:46:04', 0, 0, 0, 14, '其他', 1, '2019-05-24 23:46:04', '2019-05-24 23:46:04');
INSERT INTO `tweet` VALUES (142, 0, '学校', NULL, '2019-05-24 23:46:12', 0, 0, 0, 14, '其他', 1, '2019-05-24 23:46:12', '2019-05-24 23:46:12');
INSERT INTO `tweet` VALUES (143, 0, '这种', NULL, '2019-05-24 23:46:38', 0, 0, 0, 15, '其他', 1, '2019-05-24 23:46:38', '2019-05-24 23:46:38');
INSERT INTO `tweet` VALUES (144, 0, '密码undefinedundefinedundefined', NULL, '2019-05-24 23:49:48', 0, 0, 0, 16, '其他', 1, '2019-05-24 23:49:48', '2019-05-24 23:49:48');
INSERT INTO `tweet` VALUES (145, 0, '密码undefinedundefinedundefined', NULL, '2019-05-24 23:50:49', 0, 0, 0, 7, '其他', 1, '2019-05-24 23:50:49', '2019-05-24 23:50:49');
INSERT INTO `tweet` VALUES (146, 0, '这种undefinedundefinedundefined', NULL, '2019-05-25 00:17:55', 0, 0, 0, 11, '其他', 1, '2019-05-25 00:17:55', '2019-05-25 00:17:55');
INSERT INTO `tweet` VALUES (147, 0, '这种undefinedundefinedundefined', NULL, '2019-05-25 00:23:06', 0, 0, 0, 12, '其他', 1, '2019-05-25 00:23:06', '2019-05-25 00:23:06');
INSERT INTO `tweet` VALUES (148, 0, 'undefinedundefinedundefined', NULL, '2019-05-25 00:23:15', 0, 0, 0, 12, '其他', 1, '2019-05-25 00:23:15', '2019-05-25 00:23:15');
INSERT INTO `tweet` VALUES (149, 0, 'undefinedundefinedundefined', NULL, '2019-05-25 00:23:18', 0, 0, 0, 13, '其他', 1, '2019-05-25 00:23:18', '2019-05-25 00:23:18');
INSERT INTO `tweet` VALUES (150, 0, '学校undefinedundefinedundefined', NULL, '2019-05-25 00:27:38', 0, 0, 0, 12, '其他', 1, '2019-05-25 00:27:38', '2019-05-25 00:27:38');
INSERT INTO `tweet` VALUES (151, 0, 'undefinedundefinedundefined', NULL, '2019-05-25 00:27:44', 0, 0, 0, 11, '其他', 1, '2019-05-25 00:27:44', '2019-05-25 00:27:44');
INSERT INTO `tweet` VALUES (152, 0, 'undefinedundefinedundefined', NULL, '2019-05-25 00:27:46', 0, 0, 0, 12, '其他', 1, '2019-05-25 00:27:46', '2019-05-25 00:27:46');
INSERT INTO `tweet` VALUES (153, 0, '这种undefinedundefinedundefined', NULL, '2019-05-25 00:28:42', 0, 0, 0, 11, '其他', 1, '2019-05-25 00:28:42', '2019-05-25 00:28:42');
INSERT INTO `tweet` VALUES (154, 0, '宿舍nullnull', NULL, '2019-05-25 00:43:15', 0, 0, 0, 10, '其他', 1, '2019-05-25 00:43:15', '2019-05-25 00:43:15');
INSERT INTO `tweet` VALUES (155, 0, 'nullnull', NULL, '2019-05-25 00:43:19', 0, 0, 0, 9, '其他', 1, '2019-05-25 00:43:19', '2019-05-25 00:43:19');
INSERT INTO `tweet` VALUES (156, 0, '沙发沙发', NULL, '2019-05-25 00:53:47', 0, 0, 0, 7, '其他', 1, '2019-05-25 00:53:47', '2019-05-25 00:53:47');
INSERT INTO `tweet` VALUES (157, 0, '啊手动阀', NULL, '2019-05-25 00:54:37', 0, 0, 0, 6, '其他', 1, '2019-05-25 00:54:37', '2019-05-25 00:54:37');
INSERT INTO `tweet` VALUES (158, 0, '这种', NULL, '2019-05-25 00:55:18', 0, 0, 0, 5, '其他', 1, '2019-05-25 00:55:18', '2019-05-25 00:55:18');
INSERT INTO `tweet` VALUES (159, 0, '阿斯蒂', NULL, '2019-05-25 00:59:11', 0, 0, 0, 4, '其他', 1, '2019-05-25 00:59:11', '2019-05-25 00:59:11');
INSERT INTO `tweet` VALUES (160, 0, '撒打发', NULL, '2019-05-25 01:02:02', 0, 0, 0, 3, '其他', 0, '2019-05-25 01:02:02', '2019-05-25 01:02:02');
INSERT INTO `tweet` VALUES (161, 0, '', NULL, '2019-05-25 01:02:05', 0, 0, 0, 3, '其他', 0, '2019-05-25 01:02:05', '2019-05-25 01:02:05');
INSERT INTO `tweet` VALUES (162, 0, '', NULL, '2019-05-25 01:04:04', 0, 0, 0, 3, '其他', 0, '2019-05-25 01:04:04', '2019-05-25 01:04:04');
INSERT INTO `tweet` VALUES (163, 0, '新消息', NULL, '2019-05-25 01:04:16', 0, 0, 0, 3, '其他', 0, '2019-05-25 01:04:16', '2019-05-25 01:04:16');
INSERT INTO `tweet` VALUES (164, 0, '在', NULL, '2019-05-25 01:04:56', 0, 0, 0, 12, '其他', 0, '2019-05-25 01:04:56', '2019-05-25 01:04:56');
INSERT INTO `tweet` VALUES (165, 0, '杀杀杀', NULL, '2019-05-25 01:08:11', 0, 0, 0, 14, '其他', 0, '2019-05-25 01:08:11', '2019-05-25 01:08:11');
INSERT INTO `tweet` VALUES (166, 0, '酷酷酷', NULL, '2019-05-25 01:10:08', 0, 0, 0, 15, '其他', 0, '2019-05-25 01:10:08', '2019-05-25 01:10:08');
INSERT INTO `tweet` VALUES (167, 0, '辑简洁', NULL, '2019-05-25 01:13:48', 0, 0, 0, 18, '其他', 0, '2019-05-25 01:13:48', '2019-05-25 01:13:48');
INSERT INTO `tweet` VALUES (168, 0, '啊沙发上', NULL, '2019-05-25 01:15:32', 0, 0, 0, 30, '其他', 0, '2019-05-25 01:15:32', '2019-05-25 01:15:32');
INSERT INTO `tweet` VALUES (169, 0, '啊手动阀', NULL, '2019-05-25 01:18:41', 0, 0, 0, 34, '其他', 0, '2019-05-25 01:18:41', '2019-05-25 01:18:41');
INSERT INTO `tweet` VALUES (170, 0, '案说法', NULL, '2019-05-25 01:19:39', 0, 0, 0, 36, '其他', 0, '2019-05-25 01:19:39', '2019-05-25 01:19:39');
INSERT INTO `tweet` VALUES (171, 0, '啊手动阀', NULL, '2019-05-25 01:24:20', 0, 0, 0, 37, '其他', 0, '2019-05-25 01:24:20', '2019-05-25 01:24:20');
INSERT INTO `tweet` VALUES (172, 0, '啊手动阀', NULL, '2019-05-25 01:25:06', 0, 0, 0, 36, '其他', 0, '2019-05-25 01:25:06', '2019-05-25 01:25:06');
INSERT INTO `tweet` VALUES (173, 0, '啊手动阀<img src=\"/weibo/upload/file/46bba7611de640bea33146402041a41b.jpg\"\n         style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/e44792ceb746420aace914d4316ab2ef.jpg\"\n         style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 01:26:18', 0, 0, 0, 38, '其他', 0, '2019-05-25 01:26:18', '2019-05-25 01:26:18');
INSERT INTO `tweet` VALUES (174, 0, 'ssss<img src=\"/weibo/upload/file/a2ce1c6ee7c74f9288f39ebf398b051f.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7f0a7f97352849bd826fdcd4a745395a.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/04ba1dd7b2b440adae8658bef56b9056.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 01:43:15', 0, 0, 0, 29, '其他', 0, '2019-05-25 01:43:15', '2019-05-25 01:43:15');
INSERT INTO `tweet` VALUES (175, 0, 'dsfasdf<img src=\"/weibo/upload/file/be4faa880679419f812a57a7ee84e983.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ce0592afba9548d5b22666bb7ea63d0f.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/af39492e62f246a191d356c304895b2f.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a5b24b7a23a244fbb928dfc56f714b97.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7a1fbff550c7435a8d70646a83b0546f.png\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a468d7d9b7ec44219e4892943a74b85f.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a95661108643496baba4b68f7ac196ab.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/39dbe038f8aa4b5eb79a9ffb5cf91aa3.png\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/41ff4b8fc52248ceb05cf1fb011c074f.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ff9dc21f1d6043608f932f3a0579cde9.png\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 01:44:43', 0, 0, 0, 27, '其他', 0, '2019-05-25 01:44:43', '2019-05-25 01:44:43');
INSERT INTO `tweet` VALUES (176, 0, 'fsdf</br><img src=\"/weibo/upload/file/f1605e94f0c74322854f79b78e1a0b38.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/3ef335c28331452d8779ed586c0b0b0d.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ce522c0838594d779488a5d673f2b689.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/35b2ad6a9a1d4e7480fbfc3fc6f2dd44.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/1fcc252961944cf09003c08b744e2e42.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/091cb21c312b4bbabfd711d283cba85a.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d0b3e5481c14429bae09cf7e45340b1a.JPG\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 01:46:44', 0, 0, 0, 54, '其他', 0, '2019-05-25 01:46:44', '2019-05-25 01:46:44');
INSERT INTO `tweet` VALUES (177, 0, 'asdsd</br><img src=\"/weibo/upload/file/9162db81b85f422fa2ee0262d0f01d53.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/0dbcd898f4c149b3a9682088c39d44cf.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/f069dd4d0e6941e9bc27a0802c9c9a73.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/c623b80ec670487fb7f0fc61f74e6672.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/4ff80687ff524a0494af9094406d97c2.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/596ba9b3c21342139825f180074e0004.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/a7dc355aa1234065a0ac7dd204b4b4e8.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n<img src=\"/weibo/upload/file/0c98abb72efc43ac9a39fd0dc0cf554a.JPG\"\nstyle=\"height: 100%;width: 100%;max-height:150px;max-width:150px;\">\n', NULL, '2019-05-25 01:50:44', 0, 4, 0, 59, '其他', 0, '2019-05-25 01:50:44', '2019-05-25 01:50:44');
INSERT INTO `tweet` VALUES (178, 0, '啊手动阀</br><img src=\"/weibo/upload/file/2c2c4413e23c458faeca0edebdcc22b5.png\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/34cbf11f6dd14b27accddd23734104e5.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/586c29d0f4a243e89e495f5621ddd06f.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 09:46:17', 0, 0, 0, 50, '其他', 0, '2019-05-25 09:46:17', '2019-05-25 09:46:17');
INSERT INTO `tweet` VALUES (179, 0, '蔡徐坤</br><img src=\"/weibo/upload/file/f0844c3709074675a2b4b470a4673343.png\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 10:08:03', 0, 0, 0, 46, '其他', 0, '2019-05-25 10:08:03', '2019-05-25 10:08:03');
INSERT INTO `tweet` VALUES (180, 0, '啊手动阀</br><img src=\"/weibo/upload/file/e109650a7adb419bb4ed2c061e49e4c1.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/3c7d375982b84493b8d533233f27b036.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/63e7a478bb20465b9f6b621ccb17f5fa.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 10:09:43', 0, 0, 0, 44, '其他', 0, '2019-05-25 10:09:43', '2019-05-25 10:09:43');
INSERT INTO `tweet` VALUES (181, 0, '撒打发</br><img src=\"/weibo/upload/file/c24601470f974798a16de9024544c083.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bc0e9025baa94611a60e11fbd67243ac.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/5ce528b571f742cdb339a8fbb543901c.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 10:10:49', 0, 0, 0, 44, '其他', 0, '2019-05-25 10:10:49', '2019-05-25 10:10:49');
INSERT INTO `tweet` VALUES (182, 0, '</br><img src=\"/weibo/upload/file/99961a274f244fcf9c65d34ba4f862b8.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ada0a6d297c7489d87e0b67af887dcc8.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/68ee04aa47ed49f6a781eba3cc688334.jpg\"\nstyle=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 10:11:01', 0, 0, 0, 44, '其他', 0, '2019-05-25 10:11:01', '2019-05-25 10:11:01');
INSERT INTO `tweet` VALUES (183, 0, 'S地方</br>', NULL, '2019-05-25 10:14:46', 0, 0, 0, 42, '其他', 0, '2019-05-25 10:14:46', '2019-05-25 10:14:46');
INSERT INTO `tweet` VALUES (184, 0, '阿发</br>', NULL, '2019-05-25 10:15:10', 0, 0, 0, 42, '其他', 0, '2019-05-25 10:15:10', '2019-05-25 10:15:10');
INSERT INTO `tweet` VALUES (185, 0, '</br>', NULL, '2019-05-25 10:15:10', 0, 0, 0, 42, '其他', 0, '2019-05-25 10:15:10', '2019-05-25 10:15:10');
INSERT INTO `tweet` VALUES (188, 0, 'asdf </br><img src=\"/weibo/upload/file/84ce425a5fdc49fc98f12d851637035c.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/6a3e57c71b6a4512bcc471d211f1b208.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b97c5db7cad64decb6e7e7b2648c3c94.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/6d44ba0f34db47c5879f5453eaad7368.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 11:54:16', 0, 0, 0, 14, '篮球', 0, '2019-05-25 11:54:16', '2019-05-25 11:54:16');
INSERT INTO `tweet` VALUES (189, 0, 'afsd</br><img src=\"/weibo/upload/file/d91b050c626c4b21ad85c21ec4c076de.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/0a7e2f87203e4ca5b69ce2a167d1bc36.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/0b51fa15199247f59f7dd1b605d090f4.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2216c0328b5346b1ba5d9b42d0e63b13.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c049bbec88bd41ee99711063a05adcee.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d34972753559468a852ee59a0b59d728.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/9e4a32495cc64cd49a13e9d7dea03bc3.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/82d67c8341dd4807b325fdf35b74690e.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:07:49', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:07:49', '2019-05-25 12:07:49');
INSERT INTO `tweet` VALUES (190, 0, '</br><img src=\"/weibo/upload/file/0029b1f78d10482e976e3c44073ad100.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7b1d183850dc4d8b8fbe642662bc5129.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/60f72cb93d2b474793873e3ec1959c78.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8cba7a9bc1c249538106655256953857.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a860e0e5a5c040f99c5bc84687e232c5.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b591546dbe23467e9cad2151dd7d5239.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/0feea6f3b5614eeba67079d30b3d9560.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b88dfee888ce43c1bc17c2e204ea4511.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:07:50', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:07:50', '2019-05-25 12:07:50');
INSERT INTO `tweet` VALUES (191, 0, '</br><img src=\"/weibo/upload/file/a6367f57b3494725b2422bc311008071.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/034786bdb3b740d3aa06a5e0256664f1.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7b1a212bd50f4e8299c4be598b381a87.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bc9fff8415dc4ebdab247c94cd63b57e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2770f48e47bd4292a8898ed06351dc90.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/6bc95d8ae4f0469b8e57d8739bb6893d.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/9091c86844044c5e977dcf03c024bcd6.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/202e88146ea74f879fa7e52de4213619.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:07:54', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:07:54', '2019-05-25 12:07:54');
INSERT INTO `tweet` VALUES (192, 0, '</br><img src=\"/weibo/upload/file/fa9d584b530c477ba55ee6e6db67e223.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/5940891575364c968807d93eb66e028e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d737bd7781794a2ea3039d9f659868f5.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/5e8c6a5fd4e04ab7a9798cdb0cc53d71.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/6055b0198ec944c4a39adc79fd0395e9.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/20603c4eacba4187a2984d2540c22ff4.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/eeeef04b44e84f2cba530e1c3651d504.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/52a37afb1f604a33a415e73f5b195e97.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:00', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:08:00', '2019-05-25 12:08:00');
INSERT INTO `tweet` VALUES (193, 0, '</br><img src=\"/weibo/upload/file/a9a706ae30484a71b5264d2811483868.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/72bbff6fde1f499498c34460f4c2df2f.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/6aed00ed883140aa935cbdb84987a0bf.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/fcfa18b2c74c465994cbd85a4bc5c96a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2ae5e1ca66734ca29a93eed6d93709b0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8b053dc3bf824ddb842f4d2055f5f61c.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2161d7217e58476581e0065326e003d5.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/af936629a33646718a0e8f40830225ee.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:03', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:08:03', '2019-05-25 12:08:03');
INSERT INTO `tweet` VALUES (194, 0, '</br><img src=\"/weibo/upload/file/b7daa9913b004b3dad78b17199a30587.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/4aa570d27b3c492e92267d8340efa70d.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d6675b23cd33420da4f3b5d55cca3b1a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/62757a9d01a24bfcaae91123b94d3da1.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2dc9683cbffd4aa796c12f0d4916e820.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/fe8cc68f0c534f9d9fa07fb2eec9784a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b7d99a16d6a04085bf82b1de3e5b93fe.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/96b5433a6dbe45ddbe67c773c9a6b6c4.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:10', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:08:10', '2019-05-25 12:08:10');
INSERT INTO `tweet` VALUES (195, 0, '</br><img src=\"/weibo/upload/file/a50ff8f3f3e44668ae2755539c0e187a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/00e5beed6df6443badcc1fc7c828e5ce.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/13fd4521cb9440299cea8379a43934d8.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ae36d5075439422eba01718bd83ebac3.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/36a54e23440848b8bbf7ac4e8db16520.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/f9f699e6b28247aa961acbdbcf41f622.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/98e910bce4ec46e1b4c93adb5a95d7be.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c77e28d287f84bc7860a3e1eed132165.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:12', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:08:12', '2019-05-25 12:08:12');
INSERT INTO `tweet` VALUES (196, 0, '</br><img src=\"/weibo/upload/file/6ea1e605e245417fbf551ad447e86fa9.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a8d62b50cfb244009699ed4a9e8f073a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/5282a48521e344459c08d3a7366db17f.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/cb420c93290040baa2fe2e4642bf3c0e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/15209c5429a041969063886621b03614.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c3336bbfdc6349e0ac221d391fe675a0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d39b663d11d0417eb44a2742c6f6e8ea.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8006ae8e0a7d44dcbc3b8358662ccf14.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:13', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:08:13', '2019-05-25 12:08:13');
INSERT INTO `tweet` VALUES (197, 0, '</br><img src=\"/weibo/upload/file/1f1fb99b48f24bf3899bba59915f1f7e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/42929398ddf044d09557db7ee8caec78.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/54833294a0c64d238a7f5799cd22cbc7.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d6e4aae9d3dc45b79b3ab7111a98e4d6.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/86d3aeced43141c4bf2f4cb170a627b7.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c885d8a255434ef593cc2ccf1cf34b19.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2718bb119f444c0a8f4d40ded3c5c80c.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d92e1b26852a4b24a1ade19b9816ddab.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:13', 0, 0, 0, 1, '音乐', 0, '2019-05-25 12:08:13', '2019-05-25 12:08:13');
INSERT INTO `tweet` VALUES (198, 0, '</br><img src=\"/weibo/upload/file/c1b93f29e641452ea19bbc36778cb5c0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/fe28c90c43f54dd09a62f9e6dab352a0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a5887bf02f974b9abefdb7880bd33825.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/9f047d27f152436ba755417506aebaec.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/64be2fdb18144919a74d1f54ca989c4a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8ca14fd5938242a69c77c2a1579f88f3.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/4690c2389fd54ca0a0b95fb0d947b3eb.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/cfff5820cebb4d529feec71d4e3470d3.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:14', 0, 0, 0, 2, '音乐', 0, '2019-05-25 12:08:14', '2019-05-25 12:08:14');
INSERT INTO `tweet` VALUES (199, 0, '</br><img src=\"/weibo/upload/file/ef2c6c7c0b3e42578327a9c137750ac4.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/27121a7de8124dc0be1831ad545ece7b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d30b4578116b4033968a715ad93e9d3d.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2aee4bc775c241859149b2b42ccfda9b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/5efe888c7d694bec83b8cbafa8a38937.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8018d6e86ec84506b139114e40938a28.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/4166e54974b647df893ea7cfd08b1e52.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bbc625e9c20e4afd8cc8debe31c643e2.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:14', 0, 0, 0, 2, '音乐', 0, '2019-05-25 12:08:14', '2019-05-25 12:08:14');
INSERT INTO `tweet` VALUES (200, 0, '</br><img src=\"/weibo/upload/file/1c34f1cd96db41a49caaf0eec064c5c9.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/5b9412fbd1164654900108dd8449d120.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7792096931174867be3fd4559c6983b1.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/fa7efb5c799a4271a86a5f8a38b89ba3.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bc55647f213a466c9f504dd390e4e1d6.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/26b7e6ca770641fc90c1663c250f4c04.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8776d8c98a46416d93aade29454c3c67.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ba7211a0764347eca9492dd84774f72c.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:15', 0, 0, 0, 2, '音乐', 0, '2019-05-25 12:08:15', '2019-05-25 12:08:15');
INSERT INTO `tweet` VALUES (201, 0, '</br><img src=\"/weibo/upload/file/d5b785bdc9674ce6b5484f96542bf311.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ff10296d6c7343bb9b83d7ef9c9621a2.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bb6967f5549e4914ac2a6f3e073d4828.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b300368cc49141808808ca8d8c8cf532.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/92adb07a9b3d40db95b43eb9d5489d42.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/e985397a42884e79914b0e65dd04a7bc.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/32e4160737154a41b647444fefa618f0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/e78e16f73dcd46abacb41826ea15bc1f.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:16', 0, 0, 0, 136, '音乐', 0, '2019-05-25 12:08:16', '2019-05-25 12:08:16');
INSERT INTO `tweet` VALUES (202, 0, '</br><img src=\"/weibo/upload/file/5e1ed5e299d74108bbac2bf932b2df3a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a72530bc6029473493a2a2532e990138.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/14429419de464ddd9e23fca3adae6f9e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2ee0e35ce513458e94bdae9ae4ab0f08.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/63aeaa5acc1f46c987504821d2ce8750.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2569ffd5904d4a1fb08d1adbaa26a3c8.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/e4bebaf6b80c4075b1fa2c34aa47bc86.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/846652cc311a4ddfae214a2e7208fd38.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:16', 0, 0, 0, 19, '音乐', 0, '2019-05-25 12:08:16', '2019-05-25 12:08:16');
INSERT INTO `tweet` VALUES (203, 0, '</br><img src=\"/weibo/upload/file/72875cac77264fa2a0088b319f1838fd.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/4d68369050ee40a5a75da73b66fcc2a0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a9be3968d9f748dfa351374d11b7e3d9.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/23154a963f9e4689a2ebf43601209a17.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/f4bdc779add64f15a2a262abb7aac253.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/dd2c84a2309c42a98fb77cb598ec13bf.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/9929f982bc9b49c6ad6486e8fe4b3c4b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d4faa1349bba496c9910c9b100c52b84.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:16', 0, 0, 0, 19, '音乐', 0, '2019-05-25 12:08:16', '2019-05-25 12:08:16');
INSERT INTO `tweet` VALUES (204, 0, '</br><img src=\"/weibo/upload/file/882d9dcc990846cab773e74d59d9fe74.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c5969689475f48fb8b34a014d3e9ff71.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/37fef71111804cbd959a68829970fe35.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/041bd5cb57124c76baeff6b1d966864f.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7713fd23baa24bdfb09a42954dcd44c0.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/f3429470c35b482283a1f2ab02bb3706.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7c2543a2feb5457381c77853d9e6f140.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/0b195b3b1afa48678ad6109ada058926.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:17', 0, 0, 0, 177, '音乐', 0, '2019-05-25 12:08:17', '2019-05-25 12:08:17');
INSERT INTO `tweet` VALUES (205, 0, '</br><img src=\"/weibo/upload/file/6bd8ae83e4184d39b510ba9b531ffd64.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/236786f1ffec4816b7b51980f7f0d495.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ea134ad36b4244989aa030718c31fc6b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/fdde8853544a402d8b31e40fdff7222b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/675febe8be17458c9f06b95c590067a9.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/fad5cb1377154f5cb77e92656bb4faff.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d4be6038f43441818643894942186b6a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/28fc3a2f75d347f1b0ef7b737fa6c9f3.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:17', 0, 0, 0, 163, '音乐', 0, '2019-05-25 12:08:17', '2019-05-25 12:08:17');
INSERT INTO `tweet` VALUES (206, 0, '</br><img src=\"/weibo/upload/file/c577baab237a4964ae3708a97b667a9d.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/6f6c5bfe219241cb9c317c800cd6fe61.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/1eb2d307891242eea655c3202e8e3650.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/08fd8cc8ab2948319fa7e6fd55b30211.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bcd13c1f907f4e42901e6216db871906.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/754064db7ad0459e9e6bff005bf18302.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/f878cd25301043b8b779efcde2959215.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/af1593258c0b444ebec6fd19dc19fdaf.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:18', 0, 0, 0, 195, '音乐', 0, '2019-05-25 12:08:18', '2019-05-25 12:08:18');
INSERT INTO `tweet` VALUES (207, 0, '</br><img src=\"/weibo/upload/file/75028a3d645243a8a648f78a317c3188.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c15b1a9629704cf4bed375529ff9537f.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/79ffebf47f104323a1bc2be0236b1fa5.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/45d3460b5fc54f159082c8fe8fa5f6df.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a4421ec028ba43da91b1230bdb7e71d6.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/76b9b780dbfe4491a8689b19879e2aad.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/57351b76c93e416ea7c37df8f0570da2.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/21f398d2646544309fa18bd16969d95e.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:20', 0, 0, 0, 202, '音乐', 0, '2019-05-25 12:08:20', '2019-05-25 12:08:20');
INSERT INTO `tweet` VALUES (208, 0, '</br><img src=\"/weibo/upload/file/75991a7f0d5148d6b9cd8a03d9ac1eda.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c44024709eca486e9f8bb49110c34a8e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/42741b695916468685125143963a0316.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d276f7507f65441fb91d3dd4b1e7d722.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/51956b5688f34dbcbd8e31bdad15515b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/4942cfff1e1443f1bf0d2aa6fe2a3b96.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/3ce659e65b3c46819c2f4cfaf251df0e.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/d037a54e8755470e962c4d5b480ead17.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:21', 0, 0, 0, 269, '音乐', 0, '2019-05-25 12:08:21', '2019-05-25 12:08:21');
INSERT INTO `tweet` VALUES (209, 0, '</br><img src=\"/weibo/upload/file/3fd62e2e012f44d6a2e4ea5ee8f79085.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ba60cedef9804868976a8f801f4176a1.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/c9b703c871424c67be048cd91adc6cff.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/9cc93b1910a34b8bb55b9863c152f982.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a84761de9f7645a385a5a954fb9723ff.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7111e383e4b9430cbc2edc2527c8af96.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7369ba4494ac449f89aa5b00ccdac600.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b3ab1efe59944ad2b1f80febc49a9720.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:08:29', 0, 0, 0, 272, '音乐', 0, '2019-05-25 12:08:29', '2019-05-25 12:08:29');
INSERT INTO `tweet` VALUES (210, 0, '</br><img src=\"/weibo/upload/file/95b917f609684a0c894547241196e6d8.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8537d75586d945c8aa3135a4b0fbd859.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/3ecb869978504f05945ef6631ec13f36.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b87c87f8118242159de92722712a2bc5.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/089041d50fe3454eaf04f93ad9e54a7a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/f0b46e7a2254495ebf662af160949c9f.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/088bec2f91454f11b651b5257856500a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b6c97436aa9d41c4a25b305ce093727d.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 12:09:01', 1, 0, 0, 273, '音乐', 0, '2019-05-25 12:09:01', '2019-05-25 12:09:01');
INSERT INTO `tweet` VALUES (211, 0, 'asdfasdf</br><img src=\"/weibo/upload/file/d4395e85bedb48dd86cccc9b817d4779.png\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/04037fbd4484498db8242023408cf6b1.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/90841de15c4d44d2bd45f5f8c0ff549b.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 13:11:18', 0, 0, 0, 287, '篮球', 0, '2019-05-25 13:11:18', '2019-05-25 13:11:18');
INSERT INTO `tweet` VALUES (212, 0, '</br><img src=\"/weibo/upload/file/1ab93eb10e8d4eba83dd7caed623819b.png\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/93eb0f8463c445cea24ea970833202e7.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/7f06b07dc6984758b8e00185537af841.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-25 13:11:19', 0, 1, 0, 287, '篮球', 0, '2019-05-25 13:11:19', '2019-05-25 13:11:19');
INSERT INTO `tweet` VALUES (216, 6, '我的微博</br><img src=\"/weibo/upload/file/14b18d40601241bfa401ad3b07d82051.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/8f06d5aed8454798b781209e65307782.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/1172953c51c64fadb549886117d2bb35.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/bd85dfe93ac04a67a17bb197e3999372.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/dd19d0d1fd5f4c6aa3bdee0c5d3afbf4.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/ec214d091cbb47e38546e437bceeba29.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-29 00:11:43', 1, 2, 1, 162, '篮球', 0, '2019-05-29 00:11:43', '2019-05-29 00:11:43');
INSERT INTO `tweet` VALUES (228, 0, '转发微博', 216, '2019-05-29 22:43:18', 0, 0, 0, 103, '其他', 0, '2019-05-29 22:43:18', '2019-05-29 22:43:18');
INSERT INTO `tweet` VALUES (232, 1, '用户1的微博</br><img src=\"/weibo/upload/file/3bfbf7fee51b471a8388299172a5167d.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b776ef0fbb8b4dcaa25b76f3b9d17ea5.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/99774fa8f88d4a8388bcb9ee8a4f55cb.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/12417b9e366044399e4a3293400972dd.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-30 22:35:29', 0, 0, 0, 15, '篮球', 0, '2019-05-30 22:35:29', '2019-05-30 22:35:29');
INSERT INTO `tweet` VALUES (233, 1, '数码微博</br><img src=\"/weibo/upload/file/bba03d3062154aaaac2aa03045ea3c19.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/2f9fd09f69d242fdadbf6b6b6744896a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/473f8a3ca01d40c6b555fbe3b7ddb75d.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/a4ee001ded824641804666175836d28a.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-30 22:36:04', 0, 0, 0, 14, '数码', 0, '2019-05-30 22:36:04', '2019-05-30 22:36:04');
INSERT INTO `tweet` VALUES (234, 1, '明星微博</br><img src=\"/weibo/upload/file/e47ae96246a443a5be2967ef209b0374.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/b890ab5c22be468db9e33e19849a859c.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/093385ba7edc4dfcbb09ca878becdd42.JPG\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n<img src=\"/weibo/upload/file/cf07bac216c3491bb22906f224251ab3.jpg\"style=\"height: 100%;width: 100%;max-height:200px;max-width:200px;\">\n', NULL, '2019-05-30 22:36:30', 0, 0, 0, 16, '明星', 0, '2019-05-30 22:36:30', '2019-05-30 22:36:30');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '邮箱号',
  `weibo_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '未设置' COMMENT '微博账号',
  `type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'USER' COMMENT '用户类型',
  `phone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1234' COMMENT '账号密码',
  `gender` varchar(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '未设置' COMMENT '性别（未设置/男/女）',
  `signature` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '大家好，我是练习时长两年半的个人练习生,喜欢唱、跳、rap、篮球' COMMENT '个性签名',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '默认昵称' COMMENT '用户昵称',
  `photo` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '用户头像.png' COMMENT '用户头像',
  `chat_background` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '聊天背景',
  `location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '未设置' COMMENT '用户所在地区',
  `online_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '离线' COMMENT '在线状态（离线/在线/隐身/忙碌）',
  `status` smallint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '账户状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '插入时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (0, '微博团队', '', 'admin', '', 'Ftek/KdELdo62TyacmWX5A==', '未设置', '我爱打篮球', '微博团队', '7ede831bb55841048faf7a875ed2d47d.png', '53e2e69a43494ea3a59a26db905e38cb.jpg', '', '离线', 0, '2019-05-23 00:50:24', '2019-05-30 22:32:48');
INSERT INTO `user` VALUES (1, 'test1@qq.com', '', 'USER', '', 'Ftek/KdELdo62TyacmWX5A==', '未设置', '大家好，我是练习时长两年半的个人练习生,喜欢唱、跳、rap、篮球', '用户1', 'a92e8e771cfa45b5a47849c50ca3fddb.png', '', '', '离线', 0, '2019-05-28 00:38:56', '2019-05-30 22:34:54');
INSERT INTO `user` VALUES (6, 'test2@qq.com', '', 'USER', '', 'Ftek/KdELdo62TyacmWX5A==', '未设置', '大家好，我是练习时长两年半的个人练习生,喜欢唱、跳、rap、篮球', '用户2', '339ba03ea90243aeb41ecc3b534c2fc0.png', '', '', '离线', 0, '2019-05-29 00:10:32', '2019-05-30 22:37:50');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(10) UNSIGNED NOT NULL COMMENT '用户id',
  `role_id` bigint(10) UNSIGNED NOT NULL COMMENT '角色id',
  `status` smallint(1) UNSIGNED NOT NULL COMMENT '状态',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_role_id`(`role_id`) USING BTREE,
  INDEX `fk_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
