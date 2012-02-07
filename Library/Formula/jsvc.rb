require 'formula'

class Jsvc < Formula
  version '1.0.8'
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url 'http://apache.oss.eznetsols.org//commons/daemon/source/commons-daemon-1.0.8-native-src.tar.gz'
  md5 '9af73bf68f01c2ee7e6994c6dab0d5e8'

  def install
    arch = Hardware.is_64_bit? ? "-arch x86_64" : "-arch i386"
    ENV.append "CFLAGS", arch
    ENV.append "LDFLAGS", arch

    prefix.install %w{ NOTICE.txt LICENSE.txt RELEASE-NOTES.txt }

    cd 'unix'
    system './configure --with-java=/System/Library/Frameworks/JavaVM.framework --with-os-type=Headers'
    system 'make'
    bin.install 'jsvc'
  end
end
