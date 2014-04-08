package spark.jobserver

import com.typesafe.config.Config
import ooyala.common.akka.InstrumentedActor
import spark.jobserver.io.JobDAO

object JobConfigActor {
  // Messages to JobConfigActor actor
  case class GetJobConfig(jobId: String)
}

/**
 * An Actor that manages the job configurations stored by the job server.
 */
class JobConfigActor(jobDao: JobDAO) extends InstrumentedActor {
  import CommonMessages.NoSuchJobId
  import JobConfigActor._

  override def wrappedReceive: Receive = {
    case GetJobConfig(jobId) =>
      sender ! jobDao.getJobConfigs.get(jobId).getOrElse(NoSuchJobId)
  }
}
