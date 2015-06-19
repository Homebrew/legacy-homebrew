require 'formula'

class Gtkspell3 < Formula
  desc "Gtk widget for highlighting and replacing misspelled words"
  homepage 'http://gtkspell.sourceforge.net/'
  url 'http://gtkspell.sourceforge.net/download/gtkspell3-3.0.3.tar.gz'
  sha1 '48197eb666e061223901fea35f54c90925f128a8'

  depends_on "gtk+3"
  depends_on "enchant"
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
