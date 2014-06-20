require "formula"

class ApacheSpark < Formula
  homepage "http://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.0.0-bin-hadoop2.tgz"
  version "1.0.0"
  sha1 "804fe9a0caff941fb791e15ea1cda45a7c2b7608"

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
