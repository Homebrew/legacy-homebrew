require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.3.0.tar.bz2'
  sha1 'ed56e8717308a56f51a6ed4c18a4335e5aacae83'
  head 'git://git.qemu-project.org/qemu.git', :using => :git

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'

  def patches
    # This patch fixes the semaphore fallback code for block devices,
    # as OS X does not implement sem_timedwait() & Co.
    #
    # It has not been merged to the 1.3.x stable branch yet.
    #
    # See https://bugs.launchpad.net/qemu/+bug/1087114
    if not build.head? then
      { :p1 => "https://github.com/qemu/qemu/commit/a795ef8dcb8cbadffc996c41ff38927a97645234.diff"}
    end
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
