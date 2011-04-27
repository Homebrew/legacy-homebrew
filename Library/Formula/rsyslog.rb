require 'formula'

class Rsyslog < Formula
  url 'http://rsyslog.com/files/download/rsyslog/rsyslog-5.8.0.tar.gz'
  homepage 'http://www.rsyslog.com'
  md5 '37562d0e71a24938a9ed7f242bd32d35'

  depends_on 'pkg-config' => :build

  def build_fat
    system './configure CC="gcc -arch i386 -arch x86_64" CXX="g++ -arch i386 -arch x86_64" CPP="gcc -E" CXXCPP="g++ -E"'
  end

  def install
    if ARGV.build_universal?
      build_fat
    else
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    end
    system "make"
    system "make install"
  end
end
