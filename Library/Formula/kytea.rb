require 'formula'

class Kytea < Formula
  homepage 'http://www.phontron.com/kytea/'
  url 'http://www.phontron.com/kytea/download/kytea-0.4.5.tar.gz'
  sha1 'af0228203f509f576f5a2dcf2c0cb44e2f36aa72'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
