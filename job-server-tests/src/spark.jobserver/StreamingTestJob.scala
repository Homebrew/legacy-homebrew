package spark.jobserver

import com.typesafe.config.Config
import org.apache.spark.streaming.{Time, Seconds, StreamingContext}

/**
 * listen on a configured port for lines
 */
object StreamingTestJob extends SparkStramingJob {
  def validate(ssc: StreamingContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(ssc: StreamingContext, config: Config): Any = {
    println("1")
    val lines = ssc.textFileStream(config.getString("test.file"))
    val words = lines.flatMap(_.split(" "))
    val pairs = words.map(word => (word, 1))
    val wordCounts = pairs.reduceByKey(_ + _)
    println("2")
    //wordCounts.compute(Time(3000))
    println("3")
    ssc.start()
    println("4")
    ssc.awaitTermination()
    println("6")
  }
}
