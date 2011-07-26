require 'formula'

class Qprint < Formula
  url 'http://www.fourmilab.ch/webtools/qprint/qprint-1.0.tar.gz'
  homepage 'http://www.fourmilab.ch/webtools/qprint'
  md5 '6dc7931376370d5be9223d0d43bec7d0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make install"
  end
end
