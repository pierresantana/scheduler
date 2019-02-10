package com.github.pierresantana.api;

import java.util.Objects;

public class JobDto {

    private String jobName;
    private String jobGroup;
    private String cronExpression;
    private String payload;

    public JobDto() {

    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getJobGroup() {
        return jobGroup;
    }

    public void setJobGroup(String jobGroup) {
        this.jobGroup = jobGroup;
    }

    public String getCronExpression() {
        return cronExpression;
    }

    public void setCronExpression(String cronExpression) {
        this.cronExpression = cronExpression;
    }

    public String getPayload() {
        return payload;
    }

    public void setPayload(String payload) {
        this.payload = payload;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        JobDto jobDto = (JobDto) o;
        return Objects.equals(jobName, jobDto.jobName) &&
                Objects.equals(jobGroup, jobDto.jobGroup) &&
                Objects.equals(cronExpression, jobDto.cronExpression) &&
                Objects.equals(payload, jobDto.payload);
    }

    @Override
    public int hashCode() {

        return Objects.hash(jobName, jobGroup, cronExpression, payload);
    }
}
