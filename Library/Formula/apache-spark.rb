require "formula"

class ApacheSpark < Formula
  homepage "https://spark.incubator.apache.org/"
  head "https://github.com/apache/spark.git", :tag => "v1.0.0-rc3" 
  version "1.0.0rc3"

  def install
    # build using internal sbt setup
    system "./sbt/sbt", "assembly"
    # remove windows stuff
    rm Dir['bin/*.cmd']
    rm Dir['sbin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/spark-shell'
  end

  test do
    system "#{libexec}/bin/run-example", "org.apache.spark.examples.SparkPi", "local"
  end
end
