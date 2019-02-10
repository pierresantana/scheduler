package com.github.pierresantana.api;

import com.github.pierresantana.job.EventJob;
import com.github.pierresantana.service.SchedulerService;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static org.quartz.TriggerBuilder.newTrigger;

@RestController
@RequestMapping("job")
public class JobSchedulerController {

    @Autowired
    private SchedulerService schedulerService;

    @PostMapping
    public ResponseEntity schedule(@RequestBody JobDto job) throws SchedulerException {

        final JobDetail jobDetail = JobBuilder.newJob()
                .withIdentity(job.getJobName(), job.getJobGroup())
                .ofType(EventJob.class)
                .build();

        final CronTrigger trigger = newTrigger()
                .withIdentity(job.getJobName(), job.getJobGroup())
                .forJob(jobDetail)
                .startNow()
                .withSchedule(CronScheduleBuilder.cronSchedule(job.getCronExpression()))
                .usingJobData("payload", job.getPayload())
                .build();

        schedulerService.scheduleJob(EventJob.class, trigger);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping
    public ResponseEntity deleteSchedule(@RequestParam(name = "jobName") String jobName,
                                         @RequestParam(name = "jobGroup") String jobGroup) throws SchedulerException {
        schedulerService.delete(jobName, jobGroup);
        return ResponseEntity.noContent().build();
    }
}
