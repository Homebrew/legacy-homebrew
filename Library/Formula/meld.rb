require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.7/meld-1.7.0.tar.xz'
  sha256 'd355dba06a39e38ffee93a6b205888db648a0308bc8a5efe3a9c7a42ed91370b'

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
