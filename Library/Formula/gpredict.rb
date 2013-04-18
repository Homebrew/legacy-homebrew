require 'formula'

class Gpredict < Formula
  homepage 'http://gpredict.oz9aec.net/'
  url 'http://downloads.sourceforge.net/project/gpredict/Gpredict/1.3/gpredict-1.3.tar.gz'
  sha1 'a02a979fb68f9be8b9294a7c4ca248aaecd73b34'

  depends_on 'gtk+'
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'curl'
  depends_on 'goocanvas'
  depends_on 'hamlib'
  depends_on 'pkg-config' => :build
  depends_on :x11 

  def install
    gettext = Formula.factory('gettext')
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" 
  end

  def test
    system "gpredict"
  end
end
