require 'formula'

class Libyaml < Formula
  url 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
  homepage 'http://pyyaml.org/wiki/LibYAML'
  md5 '36c852831d02cf90508c29852361d01b'

  def install
    ENV['CFLAGS'] = "-arch i386 -arch x86_64"
    ENV['LDFLAGS'] = "-arch i386 -arch x86_64"
    system './configure', "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
