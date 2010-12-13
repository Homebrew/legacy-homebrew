require 'formula'

class Scrollkeeper <Formula
  url 'http://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz'
  homepage 'http://scrollkeeper.sourceforge.net/'
  md5 '161eb3f29e30e7b24f84eb93ac696155'

  depends_on 'gettext'
  depends_on 'docbook'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
