require 'formula'

class Cutecom < Formula
  url 'http://cutecom.sourceforge.net/cutecom-0.22.0.tar.gz'
  homepage 'http://cutecom.sf.net'
  md5 'dd85ceecf5a60b4d9e4b21a338920561'

  depends_on 'cmake' => :build
	depends_on 'qt'

  def install
    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "cmake . #{std_cmake_parameters}"
		#system "cp -r CuteCom.app /Applications"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test cutecom`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
