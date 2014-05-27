require "formula"

#Apache Spark™ is a fast and general engine for large-scale data processing
# Run programs up to 100x faster than Hadoop MapReduce in memory, or 10x faster on disk.

class Spark091BinHadoop < Formula
  homepage "https://spark.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=spark/spark-0.9.1/spark-0.9.1-bin-hadoop2.tgz"
  sha1 "953cd042a8cc44d297af46cc6714e30d20554c4b"

  depends_on "hadoop"
  depends_on "sbt"
  option "yarn"=>optional
  option "hbase"=>optional
  option "pig"=>optional

  def install
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf docs sbin tools assembly]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

  end

  def caveats; <<-EOS.undent
    Requires Java 1.6.0 or greater.

    You must define SPARK_HOME in your .bashrc or .bash_profile

    For more details:
      http://spark.apache.org/documentation.html
    EOS
  end
end
