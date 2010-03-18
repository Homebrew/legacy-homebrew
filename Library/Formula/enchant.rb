require 'formula'

class Enchant <Formula
  url 'http://www.abisource.com/downloads/enchant/1.5.0/enchant-1.5.0.tar.gz'
  homepage 'http://www.abisource.com/projects/enchant/'
  md5 '7dfaed14e142b4a0004b770c9568ed02'

  depends_on 'glib'
  depends_on 'aspell' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
