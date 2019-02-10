package com.github.pierresantana.service;

import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.stereotype.Service;

@Service
public class SchedulerService {

    @Autowired
    private SchedulerFactoryBean schedulerFactory;

    public void register(Class<? extends Job> jobClass, JobKey jobKey, boolean replace) throws SchedulerException {
        Scheduler scheduler = schedulerFactory.getScheduler();
        JobDetail jobDetail = JobBuilder.newJob(jobClass).withIdentity(jobKey).storeDurably().build();
        scheduler.addJob(jobDetail, replace);
    }

    public void delete(String jobName, String jobGroup) throws SchedulerException {
        Scheduler scheduler = schedulerFactory.getScheduler();
        scheduler.unscheduleJob(new TriggerKey(jobName, jobGroup));
        scheduler.deleteJob(new JobKey(jobName, jobGroup));
    }

    public void scheduleJob(Class<? extends Job> jobClass, Trigger job) throws SchedulerException {
        Scheduler scheduler = schedulerFactory.getScheduler();

        if (!scheduler.checkExists(job.getJobKey())) {
            register(jobClass, job.getJobKey(), false);
        }

        if (!scheduler.checkExists(job.getKey())) {
            scheduler.scheduleJob(job);
        } else {
            scheduler.rescheduleJob(job.getKey(), job);
        }
    }
}
