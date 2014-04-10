require 'formula'

class Yara < Formula
  homepage 'https://github.com/plusvic/yara/'
  url 'https://github.com/plusvic/yara/archive/2.1.0.tar.gz'
  sha1 '8289c281a44c933e11de25953f3910fe9f8ee82e'

  depends_on 'pcre'
  depends_on 'libtool'
  depends_on 'automake'

  def install
    # Use of 'inline' requires gnu89 semantics
    ENV.append 'CFLAGS', '-std=gnu89' if ENV.compiler == :clang

    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{Formula["pcre"].opt_lib} -lpcre"

    system "bash build.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end