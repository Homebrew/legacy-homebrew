require 'formula'

class Libdbx < Formula
  url 'http://sourceforge.net/projects/ol2mbox/files/LibDBX/v1.0.4/libdbx_1.0.4.tar.gz'
  homepage 'http://sourceforge.net/projects/ol2mbox'
  md5 '65e1b1ad93560d9c487cbabb4a558a4e'

  # depends_on 'cmake' => :build

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
    # `brew test libdbx`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
