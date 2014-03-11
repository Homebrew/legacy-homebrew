require "formula"

class ApacheSpark < Formula
  homepage "https://spark.incubator.apache.org/"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-0.9.0-incubating.tgz"
  version "0.9"
  sha1 "87c7dcb52847de78085881d9192a61fcab58272c"

  def install
    # build using internal sbt setup
    system "./sbt/sbt", "assembly"
    # remove windows stuff
    rm Dir['bin/*.cmd']
    rm Dir['sbin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/spark-shell'
  end

  def caveats
    s = <<-EOS.undent
        Apache Spark has been installed into #{prefix}
        Most file live under the #{libexec} directory and
        only spark-shell has been linked.
    EOS
    s
  end

  test do
    system "#{libexec}/bin/spark-shell", "-h"
  end
end
