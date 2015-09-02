package spark.jobserver;

import com.typesafe.config.Config;
import org.apache.spark.api.java.JavaSparkContext;
import spark.jobserver.JavaSparkJob;

public class JavaHelloWorldJob extends JavaSparkJob {
  @Override
  public Object runJob(JavaSparkContext jsc, Config jobConfig) {
    return("Hello World!");
  }
}
