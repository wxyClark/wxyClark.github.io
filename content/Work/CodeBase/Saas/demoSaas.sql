/*`created_at` timestamp NOT NULL DEFAULT
 Navicat Premium Data Transfer

 Source Server         : dev
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 10.100.0.14:3306
 Source Schema         : demo

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 09/05/2024 16:13:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for business_order
-- ----------------------------
DROP TABLE IF EXISTS `business_order`;
CREATE TABLE `business_order`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `business_order_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据编码(雪花ID生成)',
  `source_code` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '来源编码',
  `reference_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联编码',
  `order_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '单据类型',
  `coop_mode` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合作模式',
  `order_status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '单据主状态',
  `order_sub_status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '某一维度的状态',
  `pay_status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '付款状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据备注',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '原因(逆向操作:驳回、取消)',
  `tag` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签(逗号分割)',
  `flow_version` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '流程版本',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_order_code`(`tenant_code`, `business_order_code`) USING BTREE,
  INDEX `idx_business_order_code`(`business_order_code`) USING BTREE,
  INDEX `idx_source_code`(`source_code`) USING BTREE,
  INDEX `idx_reference_code`(`reference_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务单据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of business_order
-- ----------------------------

-- ----------------------------
-- Table structure for business_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `business_order_detail`;
CREATE TABLE `business_order_detail`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `business_order_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据编码',
  `spu_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'SPU编码',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'SKU编码',
  `price` decimal(12, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '价格',
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '数量',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '明细备注',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_order_sku_code`(`tenant_code`, `business_order_code`, `sku_code`) USING BTREE,
  INDEX `idx_business_order_codee`(`business_order_code`) USING BTREE,
  INDEX `idx_spu_code`(`spu_code`) USING BTREE,
  INDEX `idx_sku_code`(`sku_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '单据明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of business_order_detail
-- ----------------------------

-- ----------------------------
-- Table structure for business_order_log
-- ----------------------------
DROP TABLE IF EXISTS `business_order_log`;
CREATE TABLE `business_order_log`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `business_order_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据编码',
  `action_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作类型',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作备注',
  `old_values` json NOT NULL COMMENT '修改前',
  `new_values` json NOT NULL COMMENT '修改后',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_action_type`(`action_type`) USING BTREE,
  INDEX `idx_tenant_order_code`(`tenant_code`, `business_order_code`) USING BTREE,
  INDEX `idx_business_order_code`(`business_order_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '单据操作日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of business_order_log
-- ----------------------------

-- ----------------------------
-- Table structure for business_order_log_detail
-- ----------------------------
DROP TABLE IF EXISTS `business_order_log_detail`;
CREATE TABLE `business_order_log_detail`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `business_order_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据编码',
  `trigger_app_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '触发变更的应用编码',
  `action_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作类型',
  `table_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表名称',
  `column_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '列名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作备注',
  `old_values` json NOT NULL COMMENT '修改前',
  `new_values` json NOT NULL COMMENT '修改后',
  `changed_at` timestamp NOT NULL DEFAULT '1970-01-01 08:00:01' COMMENT '变更时间',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_order_code`(`tenant_code`, `business_order_code`) USING BTREE,
  INDEX `idx_business_order_code`(`business_order_code`) USING BTREE,
  INDEX `idx_action_type`(`action_type`) USING BTREE,
  INDEX `idx_column_name`(`column_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '单据操作日志明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of business_order_log_detail
-- ----------------------------

-- ----------------------------
-- Table structure for business_order_node
-- ----------------------------
DROP TABLE IF EXISTS `business_order_node`;
CREATE TABLE `business_order_node`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `business_order_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据编码',
  `node_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '节点类型',
  `time_start` datetime NOT NULL DEFAULT '1970-01-01 08:00:01' COMMENT '开始时间',
  `time_end` datetime NOT NULL DEFAULT '1970-01-01 08:00:01' COMMENT '结束时间',
  `handler` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '负责人',
  `standard_period` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '标准时效(s)',
  `time_use` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用时(秒)',
  `flow_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '流程类型',
  `fob_order_status_start` smallint(6) NOT NULL DEFAULT 0 COMMENT '开始状态',
  `fob_order_status_end` smallint(6) NOT NULL DEFAULT 0 COMMENT '结束状态',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_order_sku_code`(`tenant_code`, `business_order_code`) USING BTREE,
  INDEX `idx_node_type`(`node_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '单据节点(有status_end时获取上一条node的结束时间、结束状态)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of business_order_node
-- ----------------------------

-- ----------------------------
-- Table structure for business_time_stage_summary
-- ----------------------------
DROP TABLE IF EXISTS `business_time_stage_summary`;
CREATE TABLE `business_time_stage_summary`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `business_order_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单据编码',
  `time_stage_1` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段1时长(s)',
  `time_stage_2` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段2时长(s)',
  `time_stage_3` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段3时长(s)',
  `time_stage_4` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段4时长(s)',
  `time_stage_5` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段5时长(s)',
  `time_stage_6` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段6时长(s)',
  `time_stage_7` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段7时长(s)',
  `time_stage_8` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阶段8时长(s)',
  `receive_order_time` datetime NOT NULL DEFAULT '1970-01-01 08:00:01' COMMENT '订单接单时间',
  `tail_complete_time` datetime NOT NULL DEFAULT '1970-01-01 08:00:01' COMMENT '尾部完成时间',
  `total_use` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '生产时长(秒)',
  `handler` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '负责人',
  `is_first` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否首单',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_order_code`(`tenant_code`, `business_order_code`) USING BTREE,
  INDEX `idx_handler`(`handler`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '单据用时汇总' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of business_time_stage_summary
-- ----------------------------

-- ----------------------------
-- Table structure for data_dict_app
-- ----------------------------
DROP TABLE IF EXISTS `data_dict_app`;
CREATE TABLE `data_dict_app`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `app_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用编码',
  `app_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用名称',
  `app_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '应用描述',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_app_code_name`(`app_code`, `app_name`) USING BTREE,
  INDEX `idx_app_name`(`app_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据字典(应用)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_dict_app
-- ----------------------------

-- ----------------------------
-- Table structure for data_dict_business
-- ----------------------------
DROP TABLE IF EXISTS `data_dict_business`;
CREATE TABLE `data_dict_business`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `business_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '业务编码',
  `business_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '业务名称',
  `business_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务描述',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_business_code_name`(`business_code`, `business_name`) USING BTREE,
  INDEX `idx_business_name`(`business_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据字典(业务)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_dict_business
-- ----------------------------

-- ----------------------------
-- Table structure for data_dict_column
-- ----------------------------
DROP TABLE IF EXISTS `data_dict_column`;
CREATE TABLE `data_dict_column`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `column_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段编码',
  `app_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用编码',
  `business_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '业务编码',
  `column_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段名',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_app_business_column`(`app_code`, `business_code`, `column_name`) USING BTREE,
  UNIQUE INDEX `uk_column_code`(`column_code`) USING BTREE,
  INDEX `idx_column_name`(`column_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据字典(列)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_dict_column
-- ----------------------------

-- ----------------------------
-- Table structure for data_dict_const
-- ----------------------------
DROP TABLE IF EXISTS `data_dict_const`;
CREATE TABLE `data_dict_const`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `app_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用编码',
  `business_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '业务编码',
  `column_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段名',
  `value` int(10) NOT NULL DEFAULT 0 COMMENT '常量值',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '含义',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_column_code_value`(`column_code`, `value`) USING BTREE,
  INDEX `idx_business_code`(`business_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据字典(常量值)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_dict_const
-- ----------------------------

-- ----------------------------
-- Table structure for flow
-- ----------------------------
DROP TABLE IF EXISTS `flow`;
CREATE TABLE `flow`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程编码(F+雪花ID)',
  `app_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用编码',
  `business_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '业务类型',
  `status_column` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态字段',
  `version` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '版本号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `is_published` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否已发布，1是，2否(发布后不可编辑)',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_flow_code`(`flow_code`) USING BTREE COMMENT '流程编码全局唯一',
  UNIQUE INDEX `uk_app_business_ver`(`app_code`, `business_code`, `version`) USING BTREE COMMENT '应用流程版本'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作流主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of flow
-- ----------------------------

-- ----------------------------
-- Table structure for flow_action
-- ----------------------------
DROP TABLE IF EXISTS `flow_action`;
CREATE TABLE `flow_action`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `action_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '行为编码(A+雪花ID)',
  `flow_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名用于登录',
  `flow_version` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '版本号',
  `app_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用编码',
  `business_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '业务类型',
  `action_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '行为名称',
  `common_condition` json NULL COMMENT '通用可执行条件',
  `scenes_condition` json NULL COMMENT '区分场景的判定条件',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `start_status` int(10) NOT NULL DEFAULT 0 COMMENT '起始状态值',
  `target_status` int(10) NOT NULL DEFAULT 0 COMMENT '目标状态值',
  `belong_to_node` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '归属节点',
  `trigger` json NULL COMMENT '触发行为',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_action_code`(`action_code`) USING BTREE COMMENT '行为编码全局唯一',
  UNIQUE INDEX `uk_flow_path`(`flow_code`, `start_status`, `target_status`) USING BTREE COMMENT '同一个流程下行为不重复'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作流行为表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of flow_action
-- ----------------------------

-- ----------------------------
-- Table structure for payment_account
-- ----------------------------
DROP TABLE IF EXISTS `payment_account`;
CREATE TABLE `payment_account`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '租户编码',
  `payment_type` tinyint(2) UNSIGNED NOT NULL DEFAULT 1 COMMENT '付款方式 1.现金 2.转账 3.支付宝',
  `bank_name` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开户银行(总行)',
  `sub_bank_name` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开户银行(支行)',
  `bank_card` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '银行卡(银行账户)',
  `bank_card_name` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '银行卡账户名(银行账号用户名)',
  `bank_of_deposit_province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开户行省',
  `bank_of_deposit_city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开户行市',
  `bank_of_deposit_area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开户行县',
  `identity_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '身份证号',
  `alipay_account` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付宝账号',
  `alipay_account_name` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付宝账号名',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_code`(`tenant_code`) USING BTREE COMMENT '租户编码',
  INDEX `idx_alipay_account`(`alipay_account`) USING BTREE,
  INDEX `idx_bank_card`(`bank_card`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '付款信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment_account
-- ----------------------------

-- ----------------------------
-- Table structure for rbac_permission
-- ----------------------------
DROP TABLE IF EXISTS `rbac_permission`;
CREATE TABLE `rbac_permission`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `permission_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限编码',
  `permission_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限名称',
  `parent_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '上级编码',
  `type` tinyint(3) NOT NULL COMMENT '资源类型(1:菜单;2:按钮;3:其他)',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单路径',
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '层级',
  `support_coop_mode` json NULL COMMENT '支持的合作模式',
  `uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '前端路由',
  `route` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '后端路由',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 50000 COMMENT '排序(升序)',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图标',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(1:启用;2:禁用)',
  `is_show` tinyint(2) NOT NULL DEFAULT 1 COMMENT '是否展示(1:是;2:否)',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_menu_code`(`permission_code`) USING BTREE,
  INDEX `idx_menu_name`(`permission_name`) USING BTREE,
  INDEX `idx_parent_code`(`parent_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rbac_permission
-- ----------------------------

-- ----------------------------
-- Table structure for rbac_role
-- ----------------------------
DROP TABLE IF EXISTS `rbac_role`;
CREATE TABLE `rbac_role`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `role_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '岗位编码',
  `role_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '岗位名称',
  `parent_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '上级岗位编码',
  `type` tinyint(3) NOT NULL COMMENT '岗位类型（1：自定义岗位；2：固定岗位）',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(1:正常, 2:禁用)',
  `position` tinyint(3) NOT NULL DEFAULT 1 COMMENT '岗位级别(权限标识)',
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '路径',
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '层级',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code_role_code`(`tenant_code`, `role_code`) USING BTREE,
  INDEX `idx_parent_code`(`parent_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组织架构(岗位)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rbac_role
-- ----------------------------

-- ----------------------------
-- Table structure for rbac_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `rbac_role_permission`;
CREATE TABLE `rbac_role_permission`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tennat_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '账户编码',
  `role_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `menu_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单编码',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tennat_code_role_code_menu_code`(`tennat_code`, `role_code`, `menu_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rbac_role_permission
-- ----------------------------

-- ----------------------------
-- Table structure for rbac_user_role
-- ----------------------------
DROP TABLE IF EXISTS `rbac_user_role`;
CREATE TABLE `rbac_user_role`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '账户编码',
  `role_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位ID',
  `user_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '用户ID',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code_role_user`(`tenant_code`, `role_code`, `user_name`) USING BTREE,
  INDEX `idx_user_name`(`user_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rbac_user_role
-- ----------------------------

-- ----------------------------
-- Table structure for request_log_Ym
-- ----------------------------
DROP TABLE IF EXISTS `request_log_Ym`;
CREATE TABLE `request_log_Ym`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `mes_account_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'MES账户编码',
  `user_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人',
  `app_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用编码',
  `uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '路由URI',
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'IP地址',
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '浏览器',
  `params` json NULL COMMENT '参数',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mes_account_code_user`(`mes_account_code`, `user_name`) USING BTREE,
  INDEX `idx_uri`(`uri`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '接口访问日志(按年月分表)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of request_log_Ym
-- ----------------------------

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `company_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '公司名称',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态，1是启用，2是禁用',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant
-- ----------------------------

-- ----------------------------
-- Table structure for tenant_cooperate_relation
-- ----------------------------
DROP TABLE IF EXISTS `tenant_cooperate_relation`;
CREATE TABLE `tenant_cooperate_relation`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '租户编码',
  `customer_tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '合作商编码',
  `cooperate_status` tinyint(3) NOT NULL DEFAULT 0 COMMENT '合作状态(1:试用;2:合作;3:暂停;4:停止;)',
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '全称',
  `short_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '简称',
  `type` json NOT NULL COMMENT '合作类型',
  `contact_info` json NOT NULL COMMENT '联系信息',
  `bind_at` timestamp NOT NULL DEFAULT '1970-01-01 08:00:01' COMMENT '绑定时间',
  `payment_period` tinyint(2) UNSIGNED NULL DEFAULT 1 COMMENT '供应商账期 1.无账期 2.周结7天 3.半月结15天 4.月结30天 5.月结60天 6.月结90天',
  `payment_account_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '付款账号信息',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code_short_name`(`tenant_code`, `short_name`) USING BTREE COMMENT '简称不允许重复',
  UNIQUE INDEX `uk_tenant_code_full_name`(`tenant_code`, `full_name`) USING BTREE COMMENT '全称不允许重复',
  INDEX `idx_customer_tenant_code`(`customer_tenant_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合作关系' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tenant_cooperate_relation
-- ----------------------------

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `logo` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'LOGO',
  `slogn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标语',
  `contact_person` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '联系人',
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `tel` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '座机号码',
  `address` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `province` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '省id',
  `city` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '市id',
  `area` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '区id',
  `payment_account` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '付款账号',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_code`) USING BTREE,
  INDEX `idx_province_city_area`(`province`, `city`, `area`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_info
-- ----------------------------

-- ----------------------------
-- Table structure for tenant_user
-- ----------------------------
DROP TABLE IF EXISTS `tenant_user`;
CREATE TABLE `tenant_user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tenant_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '租户编码',
  `user_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户名(登录用)',
  `nickname` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户名(展示用)',
  `is_main_account` tinyint(3) UNSIGNED NOT NULL DEFAULT 2 COMMENT '是否为主账号(1:是, 2:否)',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'token',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(1:启用;2:停用;3:禁用)',
  `created_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人(编码)',
  `updated_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '更新人(编码)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code_user_name`(`tenant_code`, `user_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_user
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
