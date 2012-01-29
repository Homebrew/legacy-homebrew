require 'formula'

class Wv2 < Formula
  url 'http://downloads.sourceforge.net/project/wvware/wv2/0.3.1/wv2-0.3.1.tar.bz2'
  homepage 'http://wvware.sourceforge.net/'
  md5 '4a20200141cb1299055f2bf13b56989d'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libgsf'
  depends_on 'libiconv'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test wv2`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
