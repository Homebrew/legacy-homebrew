require 'formula'

class TaLib < Formula
  url 'http://sourceforge.net/projects/ta-lib/files/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz'
  homepage 'http://ta-lib.org/index.html'
  md5 '308e53b9644213fc29262f36b9d3d9b9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test ta-lib`. Remove this comment before submitting
    # your pull request!
    system "#{bin}/ta-lib"
  end
end
