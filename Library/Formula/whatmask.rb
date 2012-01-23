require 'formula'

class Whatmask < Formula
  url 'http://downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz'
  homepage 'http://www.laffeycomputer.com/whatmask.html'
  md5 '26aeff74dbba70262ccd426e681dcf4a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
