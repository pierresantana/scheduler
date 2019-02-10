# Spring Boot Quartz Scheduler

Quartz scheduler implementation using JobStore with PostgreSQL.

## Configuration

First of all, you may need to be running a PostgreSQL instance, that is out of the scope of this article.
As an alternative, you can run PostgreSQL in a container using [Docker](https://hub.docker.com/_/postgres).

After PostgreSQL is running and accessible, set connections params in application.yml.

```yaml
spring:
  datasource:
    driver: org.postgresql.Driver
    url: jdbc:postgresql://<ip-address>:<port>/<db-name>
    username: <db-user>
    password: <db-pass>
```

## Usage

Run the app:

```bash
$ ./mvnw spring-boot:run
```

### Schedule a new job:

```bash
$ curl -X POST \
    'http://localhost:8080/job' \
    -H 'content-type: application/json' \
    -d '{
  	"jobName": "JobTest",
  	"jobGroup": "JobGroup",
  	"cronExpression": "0/2 * * ? * *",
  	"payload": "Testing scheduler job"
  }'
```

This job will be fired every 2 seconds.

Cron expression could be done using [Cron Expression Generator & Explainer - Quartz](https://www.freeformatter.com/cron-expression-generator-quartz.html).

### Deleting a job:

```bash
$ curl -X DELETE \
    'http://localhost:8080/job?jobName=JobTest&jobGroup=JobGroup'
```