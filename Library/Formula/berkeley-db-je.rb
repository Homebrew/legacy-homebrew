require 'formula'

class BerkeleyDbJe < Formula
  version '5.0.34'
  url "http://download.oracle.com/maven/com/sleepycat/je/#{version}/je-#{version}.jar"
  homepage 'http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html'
  md5 '09fa2cb8431bb4ca5a0a0f83d3d57ed0'

  def install
    libexec.install "je-#{version}.jar"
  end
end
