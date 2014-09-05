require "formula"

class ApacheSpark < Formula
  homepage "http://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.0.2-bin-hadoop2.tgz"
  version "1.0.2"
  sha1 "7a456cef4628228251e541b9c8ed3c55991fb9b7"

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
