require 'formula'

class Newsbeuter <Formula
  url 'http://www.newsbeuter.org/downloads/newsbeuter-2.2.tar.gz'
  homepage 'http://www.newsbeuter.org'
  md5 '2add1dfe8d3684e67ab75f0c5172c705'

  depends_on 'gettext'
  depends_on 'stfl'
  depends_on 'pkg-config'
  depends_on 'sqlite'

  def install
    gettext = Formula.factory('gettext')
    inreplace 'Makefile','/usr/local',"#{prefix}"
    system "./config.sh"
    ENV.append "CXXFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"
    system "make"
    system "make install"
  end
end
