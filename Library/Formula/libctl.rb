require 'formula'

class Libctl < Formula
  url 'http://ab-initio.mit.edu/libctl/libctl-3.1.tar.gz'
  homepage 'http://ab-initio.mit.edu/wiki/index.php/Libctl'
  md5 '173fdc658b652a4ddfb983efc849e760'

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
    # `brew test libctl`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
