require "formula"

class ApacheSpark < Formula
  homepage "https://spark.apache.org/"
  head "https://github.com/apache/spark.git"
  url "https://d3kbcqa49mib13.cloudfront.net/spark-1.3.0-bin-hadoop2.4.tgz"
  version "1.3.0"
  sha1 "d94f2847bf92dd6e5a388c8126207cfe57e2c85e"

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
