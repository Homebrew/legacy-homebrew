require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu.org/download/qemu-1.1.0-1.tar.bz2'
  sha256 '1e566f8cbc33e5fb7d5f364c0fd1cdde9e921e647223b5d7ae7e5f95544b258d'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'

  fails_with :clang do
    build 318
    cause 'Compile error: global register variables are not supported'
  end

  def install
    # Disable the sdl backend. Let it use CoreAudio instead.
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --disable-bsd-user
      --disable-guest-agent
      --disable-sdl
    ]
    if MacOS.prefer_64_bit?
      args << '--target-list=x86_64-softmmu'
    else
      args << '--target-list=i386-softemu'
    end
    system "./configure", *args
    system "make install"
  end
end
