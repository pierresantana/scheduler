--liquibase formatted sql
--changeset pierre.santana:1
--comment: https://github.com/quartznet/quartznet/blob/master/database/tables/tables_postgres.sql
CREATE TABLE qrtz_job_details
  (
    sched_name VARCHAR(120) NOT NULL,
	job_name  VARCHAR(200) NOT NULL,
    job_group VARCHAR(200) NOT NULL,
    description VARCHAR(250) NULL,
    job_class_name   VARCHAR(250) NOT NULL,
    is_durable BOOL NOT NULL,
    is_nonconcurrent BOOL NOT NULL,
    is_update_data BOOL NOT NULL,
	requests_recovery BOOL NOT NULL,
    job_data BYTEA NULL,
    PRIMARY KEY (sched_name,job_name,job_group)
);
--rollback DROP TABLE qrtz_job_details;

--changeset pierre.santana:2
CREATE TABLE qrtz_triggers
  (
    sched_name VARCHAR(120) NOT NULL,
	trigger_name VARCHAR(150) NOT NULL,
    trigger_group VARCHAR(150) NOT NULL,
    job_name  VARCHAR(200) NOT NULL,
    job_group VARCHAR(200) NOT NULL,
    description VARCHAR(250) NULL,
    next_fire_time BIGINT NULL,
    prev_fire_time BIGINT NULL,
    priority INTEGER NULL,
    trigger_state VARCHAR(16) NOT NULL,
    trigger_type VARCHAR(8) NOT NULL,
    start_time BIGINT NOT NULL,
    end_time BIGINT NULL,
    calendar_name VARCHAR(200) NULL,
    misfire_instr SMALLINT NULL,
    job_data BYTEA NULL,
    PRIMARY KEY (sched_name,trigger_name,trigger_group),
    FOREIGN KEY (sched_name,job_name,job_group)
		REFERENCES qrtz_job_details(sched_name,job_name,job_group)
);
--rollback DROP TABLE qrtz_triggers;

--changeset pierre.santana:3
CREATE TABLE qrtz_simple_triggers
  (
    sched_name VARCHAR(120) NOT NULL,
	trigger_name VARCHAR(150) NOT NULL,
    trigger_group VARCHAR(150) NOT NULL,
    repeat_count BIGINT NOT NULL,
    repeat_interval BIGINT NOT NULL,
    times_triggered BIGINT NOT NULL,
    PRIMARY KEY (sched_name,trigger_name,trigger_group),
    FOREIGN KEY (sched_name,trigger_name,trigger_group)
		REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group) ON DELETE CASCADE
);
--rollback DROP TABLE qrtz_simple_triggers;

--changeset pierre.santana:4
CREATE TABLE QRTZ_SIMPROP_TRIGGERS
  (
    sched_name VARCHAR (120) NOT NULL,
    trigger_name VARCHAR (150) NOT NULL ,
    trigger_group VARCHAR (150) NOT NULL ,
    str_prop_1 VARCHAR (512) NULL,
    str_prop_2 VARCHAR (512) NULL,
    str_prop_3 VARCHAR (512) NULL,
    int_prop_1 INTEGER NULL,
    int_prop_2 INTEGER NULL,
    long_prop_1 BIGINT NULL,
    long_prop_2 BIGINT NULL,
    dec_prop_1 NUMERIC NULL,
    dec_prop_2 NUMERIC NULL,
    bool_prop_1 BOOL NULL,
    bool_prop_2 BOOL NULL,
	time_zone_id VARCHAR(80) NULL,
	PRIMARY KEY (sched_name,trigger_name,trigger_group),
    FOREIGN KEY (sched_name,trigger_name,trigger_group)
		REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group) ON DELETE CASCADE
);
--rollback DROP TABLE QRTZ_SIMPROP_TRIGGERS;

--changeset pierre.santana:5
CREATE TABLE qrtz_cron_triggers
  (
    sched_name VARCHAR (120) NOT NULL,
    trigger_name VARCHAR(150) NOT NULL,
    trigger_group VARCHAR(150) NOT NULL,
    cron_expression VARCHAR(250) NOT NULL,
    time_zone_id VARCHAR(80),
    PRIMARY KEY (sched_name,trigger_name,trigger_group),
    FOREIGN KEY (sched_name,trigger_name,trigger_group)
		REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group) ON DELETE CASCADE
);
--rollback DROP TABLE qrtz_cron_triggers;

--changeset pierre.santana:6
CREATE TABLE qrtz_blob_triggers
  (
    sched_name VARCHAR (120) NOT NULL,
    trigger_name VARCHAR(150) NOT NULL,
    trigger_group VARCHAR(150) NOT NULL,
    blob_data BYTEA NULL,
    PRIMARY KEY (sched_name,trigger_name,trigger_group),
    FOREIGN KEY (sched_name,trigger_name,trigger_group)
		REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group) ON DELETE CASCADE
);
--rollback DROP TABLE qrtz_blob_triggers;

--changeset pierre.santana:7
CREATE TABLE qrtz_calendars
  (
    sched_name VARCHAR (120) NOT NULL,
    calendar_name  VARCHAR(200) NOT NULL,
    calendar BYTEA NOT NULL,
    PRIMARY KEY (sched_name,calendar_name)
);
--rollback DROP TABLE qrtz_calendars;

--changeset pierre.santana:8
CREATE TABLE qrtz_paused_trigger_grps
  (
    sched_name VARCHAR (120) NOT NULL,
    trigger_group VARCHAR(150) NOT NULL,
    PRIMARY KEY (sched_name,trigger_group)
);
--rollback DROP TABLE qrtz_paused_trigger_grps;

--changeset pierre.santana:9
CREATE TABLE qrtz_fired_triggers
  (
    sched_name VARCHAR (120) NOT NULL,
    entry_id VARCHAR(140) NOT NULL,
    trigger_name VARCHAR(150) NOT NULL,
    trigger_group VARCHAR(150) NOT NULL,
    instance_name VARCHAR(200) NOT NULL,
    fired_time BIGINT NOT NULL,
	sched_time BIGINT NOT NULL,
    priority INTEGER NOT NULL,
    state VARCHAR(16) NOT NULL,
    job_name VARCHAR(200) NULL,
    job_group VARCHAR(200) NULL,
    is_nonconcurrent BOOL NOT NULL,
    requests_recovery BOOL NULL,
    PRIMARY KEY (sched_name,entry_id)
);
--rollback DROP TABLE qrtz_fired_triggers;

--changeset pierre.santana:10
CREATE TABLE qrtz_scheduler_state
  (
    sched_name VARCHAR (120) NOT NULL,
    instance_name VARCHAR(200) NOT NULL,
    last_checkin_time BIGINT NOT NULL,
    checkin_interval BIGINT NOT NULL,
    PRIMARY KEY (sched_name,instance_name)
);
--rollback DROP TABLE qrtz_scheduler_state;

--changeset pierre.santana:11
CREATE TABLE qrtz_locks
  (
    sched_name VARCHAR (120) NOT NULL,
    lock_name  VARCHAR(40) NOT NULL,
    PRIMARY KEY (sched_name,lock_name)
);
--rollback DROP TABLE qrtz_locks;

--changeset pierre.santana:12
create index idx_qrtz_j_req_recovery on qrtz_job_details(requests_recovery);
--rollback DROP INDEX idx_qrtz_j_req_recovery;

--changeset pierre.santana:13
create index idx_qrtz_t_next_fire_time on qrtz_triggers(next_fire_time);
--rollback DROP INDEX idx_qrtz_t_next_fire_time;

--changeset pierre.santana:14
create index idx_qrtz_t_state on qrtz_triggers(trigger_state);
--rollback DROP INDEX idx_qrtz_t_state;

--changeset pierre.santana:15
create index idx_qrtz_t_nft_st on qrtz_triggers(next_fire_time,trigger_state);
--rollback DROP INDEX idx_qrtz_t_nft_st;

--changeset pierre.santana:16
create index idx_qrtz_ft_trig_name on qrtz_fired_triggers(trigger_name);
--rollback DROP INDEX idx_qrtz_ft_trig_name;

--changeset pierre.santana:17
create index idx_qrtz_ft_trig_group on qrtz_fired_triggers(trigger_group);
--rollback DROP INDEX idx_qrtz_ft_trig_group;

--changeset pierre.santana:18
create index idx_qrtz_ft_trig_nm_gp on qrtz_fired_triggers(sched_name,trigger_name,trigger_group);
--rollback DROP INDEX idx_qrtz_ft_trig_nm_gp;

--changeset pierre.santana:19
create index idx_qrtz_ft_trig_inst_name on qrtz_fired_triggers(instance_name);
--rollback DROP INDEX idx_qrtz_ft_trig_inst_name;

--changeset pierre.santana:20
create index idx_qrtz_ft_job_name on qrtz_fired_triggers(job_name);
--rollback DROP INDEX idx_qrtz_ft_job_name;

--changeset pierre.santana:21
create index idx_qrtz_ft_job_group on qrtz_fired_triggers(job_group);
--rollback DROP INDEX idx_qrtz_ft_job_group;

--changeset pierre.santana:22
create index idx_qrtz_ft_job_req_recovery on qrtz_fired_triggers(requests_recovery);
--rollback DROP INDEX idx_qrtz_ft_job_req_recovery;
