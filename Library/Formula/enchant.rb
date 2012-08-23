require 'formula'

class Enchant < Formula
  homepage 'http://www.abisource.com/projects/enchant/'
  url 'http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz'
  sha1 '321f9cf0abfa1937401676ce60976d8779c39536'

  depends_on 'glib'
  depends_on 'aspell'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-ispell",
                          "--disable-myspell"
    system "make install"
  end
end
