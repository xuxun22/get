create database get_model;

create user 'get_user'@'%' identified by 'Pc2@c5yj';

grant all privileges on `get_model`.* to 'get_user'@'%' identified by 'Pc2@c5yj'; 

use get_model;
-- get_model.get_config definition

CREATE TABLE `get_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `type` varchar(16) NOT NULL COMMENT '配置类型',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `value` varchar(256) NOT NULL COMMENT '值',
  `operator_id` bigint(20) NOT NULL COMMENT '操作用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='项目相关配置表';

-- get_model.get_local_predict definition

CREATE TABLE `get_local_predict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pid` varchar(20) DEFAULT NULL COMMENT '本地预测任务pid',
  `train_id` bigint(20) NOT NULL COMMENT '训练id',
  `predict_status` tinyint(1) DEFAULT NULL COMMENT '状态(1:提交,2:正在运行,3:成功,4:失败)',
  `predict_file_path` varchar(128) NOT NULL COMMENT '预测sql脚本路径',
  `predict_result_path` varchar(128) DEFAULT NULL COMMENT '发布结果路径',
  `predict_report_path` varchar(128) DEFAULT NULL COMMENT '本地预测报告文件路径',
  `src_data_type` varchar(16) NOT NULL COMMENT '源数据类型(hive,file)',
  `optional_params` varchar(512) DEFAULT NULL COMMENT '可选参数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `INDEX_JOB_ID` (`train_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='本地预测信息';

-- get_model.get_offline_predict definition

CREATE TABLE `get_offline_predict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `train_id` bigint(20) NOT NULL COMMENT '训练id',
  `frequent_type` tinyint(1) DEFAULT NULL COMMENT '调度频率(0:从不,1:每天,2:每3天,3:每7天,4:每30天)',
  `predict_status` tinyint(1) DEFAULT NULL COMMENT '发布状态(0:未发布,1:已提交,2:正在发布,3:发布成功,4:发布失败,5:下线)',
  `predict_sql_path` varchar(128) NOT NULL COMMENT '预测sql脚本路径',
  `predict_out_path` varchar(128) DEFAULT NULL COMMENT '输出路径',
  `src_data_type` varchar(16) NOT NULL COMMENT '源数据类型(hive,file)',
  `optional_params` varchar(512) DEFAULT NULL COMMENT '可选参数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `INDEX_JOB_ID` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='离线预测信息';

-- get_model.get_predict_sub_task definition

CREATE TABLE `get_predict_sub_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `task_id` bigint(20) NOT NULL COMMENT '调度任务id',
  `status` tinyint(1) NOT NULL COMMENT '任务状态(0:失败,1:成功)',
  `host_name` varchar(32) NOT NULL COMMENT '主机名',
  `partition_str` varchar(256) NOT NULL COMMENT '分区值',
  `extra_msg` varchar(512) NOT NULL COMMENT '额外字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='预测子任务表';

-- get_model.get_predict_task definition

CREATE TABLE `get_predict_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `predict_id` bigint(20) NOT NULL COMMENT '预测id',
  `project_name` varchar(100) NOT NULL COMMENT '模型名称',
  `train_id` bigint(20) NOT NULL COMMENT '训练id',
  `status` tinyint(1) NOT NULL COMMENT '状态(1:提交,2:正在运行,3:成功,4:失败,6:已更新数据,5:中断)',
  `table_name` varchar(128) DEFAULT NULL COMMENT '样本数据表名',
  `the_date` varchar(16) DEFAULT NULL COMMENT '时间分区',
  `subtask_count` int(11) DEFAULT NULL COMMENT '子任务数',
  `subtask_finish_count` int(11) DEFAULT NULL COMMENT '完成子任务数',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`,`predict_id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='预测任务';

-- get_model.get_train_record definition

CREATE TABLE `get_train_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pid` varchar(10) DEFAULT NULL COMMENT '进程号',
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `user_name` varchar(128) NOT NULL COMMENT '用户名',
  `train_type` varchar(512) NOT NULL COMMENT '训练类型',
  `core_data` varchar(256) DEFAULT NULL COMMENT '核心指标数据',
  `project_name` varchar(100) DEFAULT NULL COMMENT '项目名称',
  `train_file_path` varchar(512) NOT NULL COMMENT '训练文件路径',
  `status` tinyint(2) NOT NULL COMMENT '状态(1:提交,2:正在运行,3:成功,4:失败)',
  `src_data_type` varchar(16) NOT NULL COMMENT '源数据类型(hive,file)',
  `output_file_path` varchar(128) DEFAULT NULL COMMENT '模型输出文件路径',
  `offline_predict_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '发布状态(0:未发布,1:已提交,2:正在发布,3:发布成功,4:发布失败,5:下线)',
  `optional_params` varchar(512) DEFAULT NULL COMMENT '可选参数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- get_model.get_user definition

CREATE TABLE `get_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `login_name` varchar(64) NOT NULL COMMENT '账号',
  `user_name` varchar(32) NOT NULL COMMENT '姓名',
  `password` varchar(32) NOT NULL COMMENT '密码',
  `mobile` varchar(16) DEFAULT NULL COMMENT '联系电话',
  `is_locked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否锁定(0:否,1:是)',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除(0:正常,1:删除)',
  `organize_id` varchar(32) DEFAULT NULL COMMENT '部门id',
  `remark` varchar(128) DEFAULT NULL COMMENT '备注',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';

