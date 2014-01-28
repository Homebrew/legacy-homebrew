require 'formula'

class GnomeCommon < Formula
  homepage 'http://git.gnome.org/browse/gnome-common/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gnome-common/3.10/gnome-common-3.10.0.tar.xz'
  sha256 'aed69474a671e046523827f73ba5e936d57235b661db97900db7356e1e03b0a3'

  depends_on 'xz' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
