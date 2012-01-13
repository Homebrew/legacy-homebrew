require 'formula'

class Meep < Formula
  url 'http://ab-initio.mit.edu/meep/meep-1.1.1.tar.gz'
  homepage 'http://ab-initio.mit.edu/wiki/index.php/Meep'
  md5 '415e0cd312b6caa22b5dd612490e1ccf'

  # depends_on 'cmake'
  depends_on 'guile'
  depends_on 'libctl'
  depends_on 'gmp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libctl=/usr/local/Cellar/libctl/3.1/share/libctl"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test meep`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
