class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "https://www.apache.org/dyn/closer.cgi?path=spark/spark-1.4.1/spark-1.4.1-bin-hadoop2.6.tgz"
  version "1.4.1"
  sha256 "9cde95349cccfeb99643d2dadb63f8e88ac355e0038aae7d5029142ce94ae370"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
