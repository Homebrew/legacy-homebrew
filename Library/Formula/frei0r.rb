require 'formula'

class Frei0r < Formula
  homepage 'http://frei0r.dyne.org'
  url 'https://files.dyne.org/.xsend.php?file=frei0r/releases/frei0r-plugins-1.4.tar.gz'
  sha1 '7995d06c5412b14fa3b05647084ca9d7a0c84faa'

  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
