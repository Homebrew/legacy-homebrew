(use http://websequencediagrams.com/ to visualize sequence diagrams)

Jar routes
==========
- get a list of mapping from appName to uploadTime for all the known job jars:

        user->WebApi: GET /jars
        WebApi->JarManager: ListJars
        JarManager->WebApi: Map(appName -> uploadTime)
        WebApi->user: 200 + JSON

- upload a job jar file with an appName

        user->WebApi: POST /jars/<appName> jarFile
        WebApi->JarManager: StoreJar(appName, jarBytes)
        opt if Jar validation fails
          JarManager->WebApi: InvalidJar
          WebApi->user: 400
        end
        JarManager->WebApi: JarStored
        WebApi->user: 200

Context routes
==============
- get a list of all known contextNames

        user->WebApi: GET /contexts
        WebApi->LocalContextSupervisor: ListContexts
        LocalContextSupervisor->WebApi: Seq(contextName)
        WebApi->user: 200 + JSON

- create a context with given contextName and configuration parameters.

        user->WebApi: POST /contexts/<contextName>?numCores=<nInt>&memPerNode=512m
        WebApi->LocalContextSupervisor: AddContext(contextName)
        opt if contexts contains contextName
          LocalContextSupervisor->WebApi: ContextAlreadyExists
          WebApi->user: 400
        end
        note over LocalContextSupervisor: CREATE JobManager(JobDao, contextName, sparkMaster, contextConfig(CPU, Mem))
        LocalContextSupervisor->JobManager: Initialize
        note over JobManager: CREATE RddManager(createContextFromConfig())
        note over JobManager: createContextFromConfig(sparkMaster, contextName)
        note over JobManager: CREATE SparkContext
        JobManager->LocalContextSupervisor: Initialized(JobResultActor)
        opt If JobManager times out
        LocalContextSupervisor->WebApi: ContextInitError
        WebApi->user: failWith(error)
        end
        LocalContextSupervisor->WebApi: ContextInitialized
        WebApi->user: 200

- delete a context with given contextName

        user->WebApi: DELETE /contexts/<contextName>
        WebApi->LocalContextSupervisor: StopContext(contextName)
        opt If no such context
          LocalContextSupervisor->WebApi: NoSuchContext
          WebApi->user: 404
        end
        LocalContextSupervisor->JobManager: PoisonPill
        LocalContextSupervisor->WebApi: ContextStopped
        WebApi->user: 200


Job routes
==========
- get a list of JobInfo(jobId, contextName, JarInfo, classPath, startTime, Option(endTime), Option(Throwable)) of all known jobs

        user->WebApi: GET /jobs
        WebApi->JobInfoActor: GetJobStatuses
        note over JobInfoActor: JobDao.getJobInfos...
        JobInfoActor->WebApi: Seq[JobInfo]
        WebApi->user: 200 + JSON

- get job result with jobId

        user->WebApi: GET /jobs/<jobId>
        WebApi->JobInfoActor: GetJobResult(jobId)
        note over JobInfoActor: JobDao.getJobInfos.get(jobId)
        opt if jobId not found:
          JobInfoActor->WebApi: NoSuchJobId
          WebApi->user: 404
        end
        opt if job is running or error out:
          JobInfoActor->WebApi: JobInfo
          WebApi->user: 200 + "RUNNING" | "ERROR"
        end
        JobInfoActor->LocalContextSupervisor:GetContext(contextName)
        opt if no such context:
          LocalContextSupervisor->JobInfoActor: NoSuchContext
          note over JobInfoActor: NOT HANDLED
        end
        LocalContextSupervisor->JobInfoActor: (JobManager, JobResultActor)
        JobInfoActor->JobResultActor: GetJobResult(jobId)
        opt if jobId not in cache:
            JobResultActor->JobInfoActor: NoSuchJobId
            JobInfoActor->WebApi: NoSuchJobId
            WebApi->user: 404
        end
        JobResultActor->JobInfoActor: JobResult(jobId, Any)
        JobInfoActor->WebApi: JobResult(jobId, Any)
        WebApi->user: 200 + resultToTable(result)

- submit a job

        user->WebApi: POST /jobs/<appName, classPath, contextName, sync> configString
        WebApi->LocalContextSupervisor: GetContext(contextName)
        opt if no such context:
          LocalContextSupervisor->WebApi: NoSuchContext
          WebApi->user: 404
        end
        LocalContextSupervisor->WebApi: (JobManager, JobResultActor)
        WebApi->JobManager: StartJob(appName, clasPatch, userConfig, asyncEvents | syncEvents)
        note over JobManager: JobDao.getLastUploadTime(appName)
        opt if no such appName:
          JobManager->WebApi: NoSuchApplication
          WebApi->user: 404
        end
        note over JobManager: CREATE unique jobID
        note over JobManager: JobCache.getSparkJob(appName, uploadTime, classPath)
        opt if no such jar or classPath
          JobManager->WebApi: NoSuchClass
          WebApi->user: 404
        end
        note over JobManager: JobJarInfo(SparkJob, jarFilePath, classLoader)
        JobManager->JobStatusActor: Subscribe(jobId, WebApi, asyncEvents | syncEvents)
        JobManager->JobResultActor: Subscribe(jobId, WebApi, asyncEvents | syncEvents)
        note over JobManager: getJobFuture(jobId, JobJarInfo, JobInfo, jobConfig, sender)
        opt if too many running jobs:
          JobManager->WebApi: NoJobSlotsAvailable
          WebApi->user: 503
        end
        JobManager->JobFuture: future{}
        note over JobFuture: set up classloader
        JobFuture->JobStatusActor: JobInit
        opt if jobId known already:
          JobStatusActor->JobFuture: JobInitAlready
          note over JobFuture: NOT HANDLED
        end
        opt if Job validation fails
          JobFuture->JobStatusActor: JobValidationFailed
          JobStatusActor->WebApi: JobValicationFailed
          WebApi->user: 400
        end
        JobFuture->JobStatusActor: JobStarted
        opt if async job
          JobStatusActor->WebApi: JobStarted
          WebApi->user: 202 + jobId
        end
        note over JobFuture: SparkJob.runJob
        opt if SparkJob fails:
          JobFuture->JobStatusActor: JobErroredOut
          JobStatusActor->WebApi: JobErroredOut
          WebApi->user: "ERROR"
        end
        JobFuture->JobStatusActor: JobFinished(jobId, now)
        JobFuture->JobResultActor: JobResult(jobId, result)
        note over JobResultActor: cacheResult(jobId, result)
        opt if sync job
          JobResultActor->WebApi: JobResult(jobId, result)
          WebApi->user: 200 + JSON
        end
        note over JobResultActor: subscribers.remove(jobId)
        JobFuture->JobStatusActor: Unsubscribe(jobId, WebApi)
        JobFuture->JobResultActor: Unsubscribe(jobId, WebApi)

- kill a job with jobId

        user->WebApi: DELETE /jobs/<jobId>
        WebApi->JobInfoActor: GetJobResult(jobId)
        note over JobInfoActor: JobDao.getJobInfos.get(jobId)
        opt if jobId not found:
          JobInfoActor->WebApi: NoSuchJobId
          WebApi->user: 404
        end
        opt if job is running:
          WebApi->JobManager: KillJob(jobId)
          JobManager->WebApi: future{}
          WebApi->user: 200 + "KILLED"
        end
        opt if job has error out:
           JobInfoActor->WebApi: JobInfo
           WebApi->user: 200 + "ERROR"
        end
