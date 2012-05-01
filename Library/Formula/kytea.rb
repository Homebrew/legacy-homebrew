require 'formula'

class Kytea < Formula
  url 'http://www.phontron.com/kytea/download/kytea-0.4.1.tar.gz'
  homepage 'http://www.phontron.com/kytea/'
  md5 '97093b3ab0f607ff4237f2fb92a14d1e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
