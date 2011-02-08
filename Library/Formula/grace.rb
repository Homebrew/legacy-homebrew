require 'formula'

class Grace <Formula
  url 'http://grace.openpanel.com/grace-0.9.38.tar.gz'
  homepage 'http://grace.openpanel.com/'
  md5 '3cdbdbdba700ee84cc1ccc5fd580c4be'
  depends_on 'berkeley-db'
  depends_on 'pcre'
  depends_on 'sqlite'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
