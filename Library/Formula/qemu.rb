require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu.org/download/qemu-1.1.0-1.tar.bz2'
  sha256 '1e566f8cbc33e5fb7d5f364c0fd1cdde9e921e647223b5d7ae7e5f95544b258d'

  head 'git://git.qemu.org/qemu.git'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'

  def install
    # Disable the sdl backend. Let it use CoreAudio instead.
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --enable-tcg-interpreter
      --disable-bsd-user
      --disable-guest-agent
      --disable-sdl
    ]
    system "./configure", *args
    system "make install"
  end
end
