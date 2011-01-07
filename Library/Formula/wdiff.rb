require 'formula'

class Wdiff <Formula
  url 'http://ftp.gnu.org/gnu/wdiff/wdiff-0.6.3.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 '6f62b672202974a4f55ab50eac4021a1'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
