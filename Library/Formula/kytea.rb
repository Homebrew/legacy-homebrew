require 'formula'

class Kytea < Formula
  homepage 'http://www.phontron.com/kytea/'
  url 'http://www.phontron.com/kytea/download/kytea-0.4.6.tar.gz'
  sha1 '2fb22c64a7babff26d95874877d83a9ef1f09617'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
