require 'formula'

class Enchant < Formula
  url 'http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz'
  homepage 'http://www.abisource.com/projects/enchant/'
  md5 'de11011aff801dc61042828041fb59c7'

  depends_on 'glib'
  depends_on 'aspell' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
