require "formula"

class ApacheSparkCdh4 < Formula
  homepage "http://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.0.0-bin-cdh4.tgz"
  version "1.0.0"
  sha1 "d7e7e2095c2cde89a04229272f63c97822d0c9b8"

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
