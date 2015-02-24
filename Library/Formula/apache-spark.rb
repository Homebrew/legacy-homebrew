require "formula"

class ApacheSpark < Formula
  homepage "http://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.2.1-bin-hadoop2.4.tgz"
  version "1.2.1"
  sha1 "2c8023f339ee9a0a05ecf6cb854f1de70b324f41"

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
