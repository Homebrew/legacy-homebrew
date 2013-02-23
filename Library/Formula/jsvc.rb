require 'formula'

class Jsvc < Formula
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url 'http://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.0.10-native-src.tar.gz'
  sha1 'b76272e39fb5c4695a102227d3c52d9c717c4ede'
  version '1.0.10'

  def install
    arch = Hardware.is_64_bit? ? "-arch x86_64" : "-arch i386"
    ENV.append "CFLAGS", arch
    ENV.append "LDFLAGS", arch

    prefix.install %w{ NOTICE.txt LICENSE.txt RELEASE-NOTES.txt }

    cd 'unix'
    system './configure', '--with-java=/System/Library/Frameworks/JavaVM.framework',
                          '--with-os-type=Headers'
    system 'make'
    bin.install 'jsvc'
  end
end
