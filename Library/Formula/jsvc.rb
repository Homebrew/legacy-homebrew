require 'formula'

class Jsvc < Formula
  version '1.0.7'
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url 'http://apache.oss.eznetsols.org//commons/daemon/source/commons-daemon-1.0.7-native-src.tar.gz'
  md5 '044e996449b6b59a8cd5da87575a0007'

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.append "LDFLAGS", "-m64"

    prefix.install %w{ NOTICE.txt LICENSE.txt RELEASE-NOTES.txt }

    cd('unix')
    system './configure'
    system 'make'
    bin.install 'jsvc'
  end
end
