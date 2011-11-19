require 'formula'

class P11Kit < Formula
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.8.tar.gz'
  homepage 'http://p11-glue.freedesktop.org'
  md5 '0928ab06acbdeda48645df4791f4d28d'

  def install
    ENV.universal_binary
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
