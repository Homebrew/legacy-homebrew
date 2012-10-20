require 'formula'

class Xaw3d < Formula
  homepage 'http://freshmeat.net/projects/xaw3d'
  url 'http://xorg.freedesktop.org/archive/individual/lib/libXaw3d-1.6.1.tar.gz'
  sha1 '742f1a74bb2644c29513b66845b129864173bee7'

  depends_on 'imake' => :build
  depends_on :x11

  def install
    system './configure', "--prefix=#{prefix}", "--disable-dependency-tracking"
    system 'make'
    system 'make install'
  end
end
