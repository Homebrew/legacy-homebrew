require 'formula'

class Log4cxx < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz'
  homepage 'http://logging.apache.org/log4cxx/index.html'
  md5 'b30ffb8da3665178e68940ff7a61084c'

  fails_with_llvm "Fails with \"collect2: ld terminated with signal 11 [Segmentation fault]\"."

  def options
    [
      ["--universal", "Build for both 32 & 64 bit Intel."],
    ]
  end

  def install
    
    args = ["--prefix=#{prefix}", "--disable-debug", "--disable-doxygen", "--disable-dependency-tracking"] # Docs won't install on OS X
    
    if ARGV.build_universal?
      ENV['CFLAGS'] = "-arch i386 -arch x86_64"
      ENV['CXXFLAGS'] = "-arch i386 -arch x86_64"
      ENV['LDFLAGS'] = "-arch i386 -arch x86_64"
      args << "--disable-dependency-tracking"
    end
    
    system "./configure", *args
    system "make install"
  end
end
