require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.3.1.tar.bz2'
  sha1 '5a3ef5273b3f39418e90680b144001f97d27c2c2'

  head 'git://git.qemu-project.org/qemu.git', :using => :git

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'
  depends_on 'sdl' => :optional

  def install
    # Disable the sdl backend; use CoreAudio instead.
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --disable-bsd-user
      --disable-guest-agent
    ]
    args << build.with?('sdl') ? '--enable-sdl' : '--disable-sdl'
    system "./configure", *args
    system "make install"
  end
end
