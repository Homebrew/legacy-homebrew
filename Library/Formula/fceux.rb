require 'formula'

class Fceux < Formula
  homepage 'http://fceux.com'
  url 'http://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.2%20src/fceux-2.2.2.src.tar.gz'
  sha1 'ec50d8eae04794ba10f441a26cdb410c1cf6832b'

  option 'no-gtk', "Build without Gtk+ support"

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'sdl'
  depends_on 'libzip'
  depends_on 'gtk+' unless build.include? "no-gtk"
  depends_on 'lua'
  depends_on :x11

  def install
    args = []
    args << "GTK=0" if build.include? "no-gtk"
    system "scons", *args
    bin.install 'src/fceux'
  end
end
