require 'formula'

class Dnstracer < Formula
  url 'http://www.mavetju.org/download/dnstracer-1.9.tar.gz'
  homepage 'http://www.mavetju.org/unix/dnstracer.php'
  md5 '7db73ce3070119c98049a617fe52ea84'

  def install
    ENV.append 'LDFLAGS', '-lresolv'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
