require 'formula'

class Gtkspell < Formula
  homepage 'http://gtkspell.sourceforge.net/'
  url 'http://gtkspell.sourceforge.net/download/gtkspell-2.0.16.tar.gz'
  sha1 '49a3eaff850d119a94fc929635270f01e87cdca1'

  depends_on "gtk+"
  depends_on "enchant"
  depends_on "freetype"
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end
end
