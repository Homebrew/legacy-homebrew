package spark.jobserver

/**
 * This tests JobManagerActor of AdHoc context.
 * Pass true to isAdHoc when the JobManagerActor is created.
 */
class JobManagerActorAdHocSpec extends JobManagerSpec {

  before {
    dao = new InMemoryDAO
    manager =
      system.actorOf(JobManagerActor.props(dao, "test", JobManagerSpec.contextConfig, true))
  }

}
