require 'formula'

class Gtkwave <Formula
  url 'http://gtkwave.sourceforge.net/gtkwave-3.3.18.tar.gz'
  homepage 'http://gtkwave.sourceforge.net/'
  md5 '63d98e374d6dc0d9c70b52e4fc6960b8'

  depends_on 'gtk+'
  depends_on 'xz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
        "--prefix=#{prefix}", "--mandir=#{man}"
    system 'make install'
  end
end
