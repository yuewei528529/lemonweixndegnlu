

-------------------------------------------------------------------------------
--  task deadline
-------------------------------------------------------------------------------
CREATE TABLE TASK_DEADLINE(
	ID BIGINT NOT NULL,
	TYPE VARCHAR(100),
	DEADLINE_TIME DATETIME,
	TRIGGER_TIME DATETIME,
	REPEAT_TIMES INT,
	NOTIFICATION_TYPE VARCHAR(200),
	NOTIFICATION_RECEIVER VARCHAR(200),
	NOTIFICATION_TEMPLATE_CODE VARCHAR(200),
	REASSIGNMENT VARCHAR(200),
	OPERATION VARCHAR(200),
	TASK_ID BIGINT,
        CONSTRAINT PK_TASK_DEADLINE PRIMARY KEY(ID),
	CONSTRAINT FK_TASK_DEADLINE_TASK  FOREIGN KEY(TASK_ID) REFERENCES TASK_INFO(ID)
);

COMMENT ON TABLE TASK_DEADLINE IS '任务截止时间';
COMMENT ON COLUMN TASK_DEADLINE.ID IS '主键';
COMMENT ON COLUMN TASK_DEADLINE.TYPE IS '类型';
COMMENT ON COLUMN TASK_DEADLINE.DEADLINE_TIME IS '截止时间';
COMMENT ON COLUMN TASK_DEADLINE.TRIGGER_TIME IS '触发时间';
COMMENT ON COLUMN TASK_DEADLINE.REPEAT_TIMES IS '重复次数';
COMMENT ON COLUMN TASK_DEADLINE.NOTIFICATION_TYPE IS '提醒类型';
COMMENT ON COLUMN TASK_DEADLINE.NOTIFICATION_RECEIVER IS '提醒接收人';
COMMENT ON COLUMN TASK_DEADLINE.NOTIFICATION_TEMPLATE_CODE IS '提醒模板编码';
COMMENT ON COLUMN TASK_DEADLINE.REASSIGNMENT IS '重分配';
COMMENT ON COLUMN TASK_DEADLINE.OPERATION IS '操作';
COMMENT ON COLUMN TASK_DEADLINE.TASK_ID IS '外键，任务';


