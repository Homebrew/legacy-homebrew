require 'formula'

class Lha <Formula
  url 'http://sourceforge.jp/frs/redir.php?m=iij&f=%2Flha%2F22231%2Flha-1.14i-ac20050924p1.tar.gz'
  homepage 'http://lha.sourceforge.jp/'
  md5 '9f52430410928ba4390a73a41a36d56f'
  version '1.14i-ac20050924p1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
