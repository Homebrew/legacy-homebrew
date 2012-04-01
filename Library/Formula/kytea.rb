require 'formula'

class Kytea < Formula
  url 'http://www.phontron.com/kytea/download/kytea-0.4.0.tar.gz'
  homepage 'http://www.phontron.com/kytea/'
  md5 'b95b82303257ab50bb1301ca0a314ece'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
