package spark.jobserver

import com.google.common.annotations.VisibleForTesting
import com.typesafe.config.Config
import org.apache.spark.rdd.RDD
import org.apache.spark.streaming.StreamingContext

import scala.collection.mutable

@VisibleForTesting
object StreamingTestJob extends SparkStreamingJob {
  def validate(ssc: StreamingContext, config: Config): SparkJobValidation = SparkJobValid


  def runJob(ssc: StreamingContext, config: Config): Any = {
    val queue = mutable.Queue[RDD[String]]()
    queue += ssc.sparkContext.makeRDD(Seq("123", "test", "test2"))
    val lines = ssc.queueStream(queue)
    val words = lines.flatMap(_.split(" "))
    val pairs = words.map(word => (word, 1))
    val wordCounts = pairs.reduceByKey(_ + _)
    //do something
    wordCounts.foreachRDD(rdd => println(rdd.count()))
    ssc.start()
    ssc.awaitTermination()
  }
}
