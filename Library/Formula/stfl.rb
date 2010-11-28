require 'formula'

class Stfl <Formula
  url 'http://www.clifford.at/stfl/stfl-0.20.tar.gz'
  homepage 'http://www.clifford.at/stfl/'
  md5 '905e0b8f81fe1b5c95b8d78f56df966b'

  depends_on 'libiconv'
  depends_on 'ncursesw'

  def patches
    { :p0 => "http://svn.macports.org/repository/macports/trunk/dports/devel/stfl/files/patch-Makefile.diff" }
  end

  def install
    system "make"
    system "make install"
  end
end
