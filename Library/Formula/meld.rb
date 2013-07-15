require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.7/meld-1.7.2.tar.xz'
  sha1 '660e47ceb06fd9035a6fcac12da373f8a60fec31'

  depends_on 'intltool' => :build
  depends_on 'xz' => :build
  depends_on :x11
  depends_on 'pygtk'
  depends_on 'pygobject'
  depends_on 'rarian'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
