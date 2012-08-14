require 'formula'

class Wmctrl < Formula
  homepage 'http://sweb.cz/tripie/utils/wmctrl/'
  url 'http://tomas.styblo.name/wmctrl/dist/wmctrl-1.07.tar.gz'
  md5 '1fe3c7a2caa6071e071ba34f587e1555'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
