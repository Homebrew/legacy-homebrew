require "formula"

class ApacheSpark < Formula
  homepage "http://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop2.4.tgz"
  version "1.2.0"
  sha1 "57d19d43aa058acefbde32b2304678a8b07eaa80"

  conflicts_with 'hive', :because => 'both install `beeline` binaries'

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
