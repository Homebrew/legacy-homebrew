For full job server flow, see job-server-flow.md.

user->WebApi: POST /jobs/<appName, classPath, contextName, sync> configString
WebApi->LocalContextSupervisor: GetContext(contextName)
LocalContextSupervisor->WebApi: (JobManager, JobResultActor)
WebApi->JobManager: StartJob(appName, clasPatch, userConfig, asyncEvents | syncEvents)
JobManager->JobStatusActor: Subscribe(jobId, WebApi, asyncEvents | syncEvents)
JobManager->JobResultActor: Subscribe(jobId, WebApi, asyncEvents | syncEvents)
JobManager->JobFuture: future{}
JobFuture->JobStatusActor: JobInit
JobFuture->JobStatusActor: JobStarted
opt if async job
  JobStatusActor->WebApi: JobStarted
  WebApi->user: 202 + jobId
end
note over JobFuture: SparkJob.runJob
JobFuture->JobStatusActor: JobFinished(jobId, now)
JobFuture->JobResultActor: JobResult(jobId, result)
note over JobResultActor: cacheResult(jobId, result)
opt if sync job
  JobResultActor->WebApi: JobResult(jobId, result)
  WebApi->user: 200 + JSON
end
JobFuture->JobStatusActor: Unsubscribe(jobId, WebApi)
JobFuture->JobResultActor: Unsubscribe(jobId, WebApi)
