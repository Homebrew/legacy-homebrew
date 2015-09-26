class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "https://www.apache.org/dyn/closer.cgi?path=spark/spark-1.5.0/spark-1.5.0-bin-hadoop2.6.tgz"
  version "1.5.0"
  sha256 "d8d8ac357b9e4198dad33042f46b1bc09865105051ffbd7854ba272af726dffc"

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
