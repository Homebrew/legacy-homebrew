require 'formula'

class Rsyslog < Formula
  url 'http://rsyslog.com/files/download/rsyslog/rsyslog-5.8.0.tar.gz'
  homepage 'http://www.rsyslog.com'
  md5 '37562d0e71a24938a9ed7f242bd32d35'

  depends_on 'pkg-config' => :build

  def options
    [['--universal', 'Make a 32/64-bit Intel build.']]
  end

  def install
    if ARGV.build_universal?
      ENV['CC'] = "gcc -arch i386 -arch x86_64"
      ENV['CXX'] = "g++ -arch i386 -arch x86_64"
      ENV['CPP'] = "gcc -E"
      ENV['CXXCPP'] = "g++ -E"
      system "./configure", "--prefix=#{prefix}"
    else
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    end

    system "make"
    system "make install"
  end
end
