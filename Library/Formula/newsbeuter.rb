require 'formula'

class Newsbeuter <Formula
  url 'http://www.newsbeuter.org/downloads/newsbeuter-2.4.tar.gz'
  homepage 'http://www.newsbeuter.org/'
  md5 '67fd0d44a55e10ed1ba15b197262a35f'

  depends_on 'stfl'
  depends_on 'curl'
  depends_on 'sqlite'
  depends_on 'libxml2'
  depends_on 'gettext'

  def install
    system "make"
    system "make install prefix=#{prefix}"
  end
end
