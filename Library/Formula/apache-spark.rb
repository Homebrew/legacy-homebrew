class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  version "1.6.0"
  head "https://github.com/apache/spark.git"
  bottle :unneeded

  option "without-hadoop", "Use the -without-hadoop distribution of Spark (assumes you have a local installation of hadoop)"

  if build.without? "hadoop"
    url "https://www.apache.org/dyn/closer.lua?path=spark/spark-1.6.0/spark-1.6.0-bin-without-hadoop.tgz"
    sha256 "9f62bc1d1f7668becd1fcedd5ded01ad907246df287d2525cfc562d88a3676da"
  else
    url "https://www.apache.org/dyn/closer.lua?path=spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz"
    sha256 "439fe7793e0725492d3d36448adcd1db38f438dd1392bffd556b58bb9a3a2601"
  end

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    # spark-shell has a REPL-history type of thing but it needs to write
    # to ~/.spark_history... not necessarily sandbox-friendly! But --driver-java-options
    # lets us pass JVM flags like -D to let us override Java/Scala system properties!
    system "#{bin}/spark-shell --driver-java-options '-Duser.home=/tmp/' <<<'sc.parallelize(1 to 1000).count()'"
  end
end
