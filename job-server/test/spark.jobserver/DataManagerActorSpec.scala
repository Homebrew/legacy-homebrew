package spark.jobserver

import akka.actor.{ Props, ActorRef, ActorSystem }
import akka.testkit.{ TestKit, ImplicitSender }
import org.scalatest.{ FunSpecLike, BeforeAndAfter, BeforeAndAfterAll, Matchers }
import java.nio.file.Files

import spark.jobserver.io.DataFileDAO

object DataManagerActorSpec {
  val system = ActorSystem("test")
}

class DataManagerActorSpec extends TestKit(DataManagerActorSpec.system) with ImplicitSender
    with FunSpecLike with Matchers with BeforeAndAfter with BeforeAndAfterAll {

  import com.typesafe.config._
  import CommonMessages.NoSuchJobId
  import DataManagerActor._

  private val bytes = Array[Byte](0, 1, 2)
  private val tmpDir = Files.createTempDirectory("ut")
  private val config = ConfigFactory.empty().withValue("spark.jobserver.datadao.rootdir", ConfigValueFactory.fromAnyRef(tmpDir.toString))

  override def afterAll() {
    dao.shutdown()
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(actor)
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(DataManagerActorSpec.system)
    Files.delete(tmpDir.resolve(DataFileDAO.META_DATA_FILE_NAME))
    Files.delete(tmpDir)
  }

  val dao: DataFileDAO = new DataFileDAO(config)
  val actor: ActorRef = system.actorOf(Props(classOf[DataManagerActor], dao), "data-manager")

  describe("DataManagerActor") {
    it("should store, list and delete tmp data file") {
      val fileName = System.currentTimeMillis + "tmpFile"

      actor ! StoreData(fileName, bytes)
      val fn = expectMsgPF() {
        case Stored(msg) => msg
      }

      fn.contains(fileName) should be(true)
      dao.listFiles.exists(f => f.contains(fileName)) should be(true)
      actor ! DeleteData(fn)
      expectMsg(Deleted)
      dao.listFiles.exists(f => f.contains(fileName)) should be(false)
    }

    it("should list data files") {
      actor ! ListData

      val storedFiles = expectMsgPF() {
        case files => files
      }

      storedFiles should equal(dao.listFiles)
    }

    it("should store, list and delete several files") {
      val storedFiles = (for (ix <- 1 to 11; fileName = System.currentTimeMillis + "tmpFile" + ix) yield {
        actor ! StoreData(fileName, bytes)
        expectMsgPF() {
          case Stored(msg) => msg
        }
      }).toSet

      dao.listFiles should equal(storedFiles)
      storedFiles foreach (fn => {
        actor ! DeleteData(fn)
        expectMsg(Deleted)
      })
      dao.listFiles should equal(Set())
    }

  }
}
