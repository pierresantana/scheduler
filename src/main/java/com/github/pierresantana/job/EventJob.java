package com.github.pierresantana.job;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.*;

@DisallowConcurrentExecution
public class EventJob implements Job {

    private static final Log LOGGER = LogFactory.getLog(EventJob.class);

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        final Trigger trigger = context.getTrigger();

        LOGGER.info(String.format("Job execution <JobName: %s> <JobGroup: %s> <Payload: %s>",
                trigger.getJobKey().getName(),
                trigger.getJobKey().getGroup(),
                trigger.getJobDataMap().getString("payload")
        ));
    }
}
