package spark.jobserver.io

import com.typesafe.config._
import java.io._
import org.joda.time.DateTime
import org.slf4j.LoggerFactory
import scala.collection.mutable

object DataFileDAO {
  val EXTENSION = ".dat"
  val META_DATA_FILE_NAME = "files.data"
}

class DataFileDAO(config: Config) {
  private val logger = LoggerFactory.getLogger(getClass)

  // set of files managed by this class
  private val files = mutable.HashSet.empty[String]


  private val dataFile : File = {

    val rootDir = config.getString("spark.jobserver.datadao.rootdir")
    val rootDirFile = new File(rootDir)
    logger.trace("rootDir is {}", rootDirFile.getAbsolutePath)
    // create the data directory if it doesn't exist
    if (!rootDirFile.exists()) {
      if (!rootDirFile.mkdirs()) {
        throw new RuntimeException("Could not create directory " + rootDir)
      }
    }

    val dataFile = new File(rootDirFile, DataFileDAO.META_DATA_FILE_NAME)
    // read back all files info during startup
    if (dataFile.exists()) {
      val in = new DataInputStream(new BufferedInputStream(new FileInputStream(dataFile)))
      try {
        while (true) {
          val dataInfo = readFileInfo(in)
          addFile(dataInfo.appName)
        }
      } catch {
        case e: EOFException => // do nothing
      } finally {
        in.close()
      }
    }
    dataFile
  }

  val rootDir = dataFile.getParentFile().getAbsolutePath

  // Don't buffer the stream. I want the apps meta data log directly into the file.
  // Otherwise, server crash will lose the buffer data.
  private val dataOutputStream: DataOutputStream = new DataOutputStream(new FileOutputStream(dataFile, true))

  def shutdown() {
    try {
      dataOutputStream.close
    } catch {
      case t: Throwable =>
        logger.error("unable to close output stream")
    }
  }

  /**
   * save the given data into a new file with the given prefix, a time stamp is appended to
   * ensure uniqueness
   */
  def saveFile(aNamePrefix: String, uploadTime: DateTime, aBytes: Array[Byte]): String = {
    // The order is important. Save the file first and then log it into meta data file.
    val outFile = new File(rootDir, createFileName(aNamePrefix, uploadTime) + DataFileDAO.EXTENSION)
    val name = outFile.getAbsolutePath
    val bos = new BufferedOutputStream(new FileOutputStream(outFile))
    try {
      logger.debug("Writing {} bytes to file {}", aBytes.size, outFile.getPath)
      bos.write(aBytes)
      bos.flush()
    } finally {
      bos.close()
    }

    // log it into meta data file
    writeFileInfo(dataOutputStream, JarInfo(name, uploadTime))

    // track the new file in memory
    addFile(name)
    name
  }

  private def writeFileInfo(out: DataOutputStream, aInfo: JarInfo) {
    out.writeUTF(aInfo.appName)
    out.writeLong(aInfo.uploadTime.getMillis)
  }

  def deleteFile(aName: String) {
    if (aName.startsWith(rootDir) && files.contains(aName)) {
      // only delete the file if it is known to this class,
      // otherwise this could be abused
      new File(aName).delete
      files -= aName
    }
  }

  private def readFileInfo(in: DataInputStream) = JarInfo(in.readUTF, new DateTime(in.readLong))

  private def addFile(aName: String) {
    files += aName
  }

  def listFiles: Set[String] = files.toSet

  private def createFileName(aName: String, uploadTime: DateTime): String =
    aName + "-" + uploadTime.toString().replace(':', '_')

  private def readError(in: DataInputStream) = {
    val error = in.readUTF()
    if (error == "") None else Some(new Throwable(error))
  }

}
