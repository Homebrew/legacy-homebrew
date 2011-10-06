require 'formula'

class Armadillo < Formula
  url 'http://downloads.sourceforge.net/project/arma/armadillo-2.2.3.tar.gz'
  homepage 'http://arma.sourceforge.net/'
  md5 '5966ec93a5840c36765430b61c8d50b2'

  depends_on 'cmake'
  depends_on 'boost'

  def install
    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                      "--prefix=#{prefix}"
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test armadillo`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
