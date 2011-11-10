require 'formula'

class Whatmask < Formula
  url 'http://downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz'
  homepage 'http://www.laffeycomputer.com/whatmask.html'
  md5 '26aeff74dbba70262ccd426e681dcf4a'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "whatmask 127.0.0.1/8"
  end
end
