require 'formula'

class Libyaml < Formula
  homepage 'http://pyyaml.org/wiki/LibYAML'
  url 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
  md5 '36c852831d02cf90508c29852361d01b'

  option :universal

  def install
    args = ["--prefix=#{prefix}"]

    if build.universal?
      ENV['CFLAGS'] = "-arch i386 -arch x86_64"
      ENV['LDFLAGS'] = "-arch i386 -arch x86_64"
      args << "--disable-dependency-tracking"
    end

    system './configure', *args
    system "make install"
  end
end
