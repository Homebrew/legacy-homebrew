require 'formula'

class BerkeleyDbJe < Formula
  version '4.1.10'
  url "http://download.oracle.com/maven/com/sleepycat/je/#{version}/je-#{version}.jar"
  homepage 'http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html'
  md5 '2c51fe0dfcdb3f89f0151126b8de1e07'

  def install
    libexec.install "je-#{version}.jar"
  end
end
