require 'formula'

class Remake < Formula
  url 'http://downloads.sourceforge.net/project/bashdb/remake/3.82%2Bdbg-0.6/remake-3.82+dbg-0.6.tar.bz2'
  homepage ''
  md5 '1e6b09ba941159efab663553528f68de'
  version '3.82+dbg-0.6'
  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test remake-3.82+dbg`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
