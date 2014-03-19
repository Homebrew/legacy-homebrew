# Introduction

There are two separate ActorSystems or clusters of actors in the job server architecture.

* JobServer system - this contains the actual REST API and manages all of the job context systems.
* JobContext system - one system per JobContext.

Each JobContext could potentially run in its own process for isolation purposes, and multiple JobServers may connect to the same JobContext for HA.

# JobServer ActorSystem

Here are all the actors for the job server.

## WebApi

This is not really an actor but contains the web routes.

## ContextSupervisor

- Creates and stops JobContext actorsystems
- Sends jobs on to job contexts
- is a singleton

# JobContext ActorSystem

## JobManager

This was the "ContextManager" actor.

- one per context
- Starts JobActors for every job in the context
- returns an error if there are no more threads for jobs or capacity is full
- Starts and supervises the JobStatus and JobResult actors

## AdHocJobManager

A special JobManager for running ad-hoc jobs, which require temporary per-job JobContexts.

- When the job terminates, the JobManager cleans up the SparkContext.

## JobStatusActor

- one per JobManager
- Collects and persists job status and progress updates (iucluding exceptions) from every job in JobManager
    - JDBC updates
    - log file
    - WebSocket?
- Handles subscriptions from external actors for listening to status updates for specific jobID's
- Watches the JobActors, removing subscriptions once the actor terminates

## JobResultActor

- one per JobManager
- Collects job results
- For now, do not persist it, just keep in memory
- handles requests from external actors for the job results

## JobActor

- many per JobManager
- Invokes SparkJob.validate(), SparkJob.runJob(), etc.
- sends status updates back to JobStatus, JobResult actors
