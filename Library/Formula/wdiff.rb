require 'formula'

class Wdiff <Formula
  url 'http://ftp.gnu.org/gnu/wdiff/wdiff-0.6.0.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 '8788b9bf7d5700237508bf3aec8a9493'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
