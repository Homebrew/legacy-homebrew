require "formula"

class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "http://www.apache.org/dyn/closer.cgi?path=spark/spark-1.4.0/spark-1.4.0-bin-hadoop2.6.tgz"
  version "1.4.0"
  sha1 "c21a21531fc716b11dff1da090977f63d624b654"

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
