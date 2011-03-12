require 'formula'

class Wdiff <Formula
  url 'http://ftp.gnu.org/gnu/wdiff/wdiff-0.6.5.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 '1828209a14d01ad38c7267985f365cbf'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
