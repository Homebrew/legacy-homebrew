require 'formula'

class Wdiff <Formula
  url 'http://ftp.gnu.org/gnu/wdiff/wdiff-0.6.2.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 'bf8474129a47b3a002af969a77612593'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
