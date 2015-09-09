package spark.jobserver

import ooyala.common.akka.InstrumentedActor
import spark.jobserver.io.DataFileDAO
import spark.jobserver.util.JarUtils
import org.joda.time.DateTime

object DataManagerActor {
  // Messages to DataManager actor
  case class StoreData(name: String, bytes: Array[Byte])
  case class DeleteData(name: String)
  case object ListData

  // Responses
  case class Stored(name: String)
  case object Deleted
  case object Error
}

/**
 * An Actor that manages the data files stored by the job server to disc.
 */
class DataManagerActor(fileDao: DataFileDAO) extends InstrumentedActor {
  import DataManagerActor._
  override def wrappedReceive: Receive = {
    case ListData => sender ! fileDao.listFiles

    case DeleteData(fileName) => {
      fileDao.deleteFile(fileName)
      sender ! Deleted
    }

    case StoreData(aName, aBytes) =>
      logger.info("Storing data in file prefix {}, {} bytes", aName, aBytes.size)
      val uploadTime = DateTime.now()
      val fName = fileDao.saveFile(aName, uploadTime, aBytes)
      sender ! Stored(fName)
  }
}
