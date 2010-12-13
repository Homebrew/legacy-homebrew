require 'formula'

class Jsvc < Formula
  version '1.0.3'
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url "http://www.apache.org/dist/commons/daemon/binaries/#{version}/darwin/commons-daemon-#{version}-bin-darwin-universal.tar.gz"
  md5 '0a41394c22c80d3eb29372853d3a569d'

  def install
    bin.install 'jsvc'
  end
end
