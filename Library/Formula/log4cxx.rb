require 'formula'

class Log4cxx < Formula
  url 'http://apache.abdaal.com/logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz'
  homepage 'http://logging.apache.org/log4cxx/index.html'
  md5 'b30ffb8da3665178e68940ff7a61084c'

  fails_with_llvm "Fails with \"collect2: ld terminated with signal 11 [Segmentation fault]\"."

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Docs won't install on OS X
                          "--disable-doxygen"
    system "make install"
  end
end
