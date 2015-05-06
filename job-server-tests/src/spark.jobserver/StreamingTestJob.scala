package spark.jobserver

import com.typesafe.config.Config
import org.apache.spark.rdd.RDD
import org.apache.spark.streaming.{Time, Seconds, StreamingContext}

import scala.collection.mutable

/**
 * listen on a configured port for lines
 */
object StreamingTestJob extends SparkStramingJob {
  def validate(ssc: StreamingContext, config: Config): SparkJobValidation = SparkJobValid


  def runJob(ssc: StreamingContext, config: Config): Any = {
    val queue = mutable.Queue[RDD[String]]()
    queue += ssc.sparkContext.makeRDD(Seq("123", "test", "test2"))
    val lines = ssc.queueStream(queue)
    lines.foreachRDD(rdd => println("count: " + rdd.count()))
    val words = lines.flatMap(_.split(" "))
    words.foreachRDD(rdd => rdd.collect().foreach("test " + print(_)))
    val pairs = words.map(word => (word, 1))
    val wordCounts = pairs.reduceByKey(_ + _)
    wordCounts.foreachRDD(rdd => println(rdd.count()))
    ssc.start()
    ssc.awaitTermination()
  }
}
