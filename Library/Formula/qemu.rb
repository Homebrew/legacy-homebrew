require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.3.0.tar.bz2'
  sha1 'ed56e8717308a56f51a6ed4c18a4335e5aacae83'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'

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
