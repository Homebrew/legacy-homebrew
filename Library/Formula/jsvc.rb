require 'formula'

class Jsvc < Formula
  version '1.0.7'
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url 'http://apache.oss.eznetsols.org//commons/daemon/source/commons-daemon-1.0.7-native-src.tar.gz'
  md5 '044e996449b6b59a8cd5da87575a0007'

  def patches
    # updated sample startup scripts based on OSX note from http://commons.apache.org/daemon/jsvc.html:
    # "Use -jvm server because default client JVM is not present for all architectures."
    'https://raw.github.com/gist/1290534/samples.patch'
  end

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.append "LDFLAGS", "-m64"

    prefix.install %w{ NOTICE.txt LICENSE.txt RELEASE-NOTES.txt unix/samples }

    cd 'unix'
    system './configure'
    system 'make'
    bin.install 'jsvc'
  end
end