require 'formula'

class Yara < Formula
  homepage 'http://code.google.com/p/yara-project/'
  url 'http://yara-project.googlecode.com/files/yara-1.7.tar.gz'
  sha1 '25e90b79275124db3e592ccac1d44a9bba35d7ea'

  depends_on 'pcre'

  def install
    # Use of 'inline' requires gnu89 semantics
    ENV.append 'CFLAGS', '-std=gnu89' if ENV.compiler == :clang

    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
