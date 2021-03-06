

-------------------------------------------------------------------------------
--  task def escalation
-------------------------------------------------------------------------------
-- notification, reassignment, operation
CREATE TABLE TASK_DEF_ESCALATION(
	ID BIGINT NOT NULL,
	TYPE VARCHAR(50),
	STATUS VARCHAR(50),
	ESCALATION_CONDITION VARCHAR(200),
	VALUE VARCHAR(200),
	DEADLINE_ID BIGINT,
        CONSTRAINT PK_TASK_DEF_ESCALATION PRIMARY KEY(ID),
        CONSTRAINT FK_TASK_DEF_ESCALATION_DEADLINE FOREIGN KEY(DEADLINE_ID) REFERENCES TASK_DEF_DEADLINE(ID)
);

COMMENT ON TABLE TASK_DEF_ESCALATION IS '任务定义升级';
COMMENT ON COLUMN TASK_DEF_ESCALATION.ID IS '主键';
COMMENT ON COLUMN TASK_DEF_ESCALATION.TYPE IS '类型';
COMMENT ON COLUMN TASK_DEF_ESCALATION.STATUS IS '状态';
COMMENT ON COLUMN TASK_DEF_ESCALATION.ESCALATION_CONDITION IS '升级条件';
COMMENT ON COLUMN TASK_DEF_ESCALATION.VALUE IS '值';
COMMENT ON COLUMN TASK_DEF_ESCALATION.DEADLINE_ID IS '外键，截止时间';


