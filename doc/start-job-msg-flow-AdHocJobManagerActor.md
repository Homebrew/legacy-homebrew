title POST /jobs start new job workflow with AdHocJobManagerActor

user->WebApi: POST /jobs

WebApi->LocalContextSupervisor: GetAdHocContext
LocalContextSupervisor->WebApi: (AdHocJobManager, JobResultActor)

WebApi->AdHocJobManagerActor: StartJob(event for JobStatusActor)

note over AdHocJobManagerActor: validate appName, className

opt if Job validation fails
  AdHocJobManagerActor->WebApi: ERROR
  WebApi->user: 400
end

AdHocJobManagerActor->JobStatusActor: Subscribe(jobId, WebApi, event)
AdHocJobManagerActor->JobResultActor: Subscribe(jobId, WebApi,  JobResult)
AdHocJobManagerActor->JobFuture: CreateJob

JobFuture->JobStatusActor: JobInit(info)

note over JobFuture: SparkJob.validate()

opt if validation fails
  JobFuture->JobStatusActor: ValidationFailed
  JobStatusActor->WebApi: ValidationFailed
  WebApi->user: 400
end

JobFuture->JobStatusActor: JobStarted(jobId)

opt if async job
  JobStatusActor->WebApi: JobStarted(jobId)
  WebApi->user: 202
end

note over JobFuture: SparkJob.runJob()

JobFuture->JobStatusActor: JobFinish(jobId)
JobFuture->JobStatusActor: Unsubscribe(jobId, WebApi)

JobFuture->JobResultActor: JobResult(jobId, result)

JobFuture->AdHocJobManagerActor: JobFinish(jobId)

note over JobFuture: Terminate

note over JobResultActor: cacheResult(jobId, result)

opt if sync job
  JobResultActor->WebApi: JobResult(jobId, result)
  WebApi->user: result
end
