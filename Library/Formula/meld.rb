require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.5/meld-1.5.3.tar.xz'
  sha256 'a27890202584920db941f78c64ba79662b3cdcf5f90c0d2f140a4b52858229b9'

  depends_on 'intltool' => :build
  depends_on 'pygtk'
  depends_on 'pygobject'
  depends_on 'rarian'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
