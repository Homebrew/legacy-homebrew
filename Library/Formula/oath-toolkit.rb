require 'formula'

class OathToolkit < Formula
  url 'http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-1.10.5.tar.gz'
  homepage ''
  md5 'b15754a7419592c57b8a98cc413eb873'

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
    # `brew test oath-toolkit`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
