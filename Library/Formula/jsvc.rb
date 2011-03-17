require 'formula'

class Jsvc < Formula
  version '1.0.5'
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url "http://www.apache.org/dist/commons/daemon/binaries/#{version}/darwin/commons-daemon-#{version}-bin-darwin-universal.tar.gz"
  md5 '1d5f4b81e5ac18da0d58af421bc3c139'

  def install
    bin.install 'jsvc'
  end
end
