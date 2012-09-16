require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu.org/download/qemu-1.2.0.tar.bz2'
  sha1 '4bbfb35ca2e386e9b731c09a8eb1187c0c0795a8'

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
    system "./configure", *args
    system "make install"
  end
end
