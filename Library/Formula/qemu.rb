require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.5.0.tar.bz2'
  sha1 '52d1bd7f8627bb435b95b88ea005b71b9b1a0098'

  head 'git://git.qemu-project.org/qemu.git', :using => :git

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'
  depends_on 'sdl' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --disable-bsd-user
      --disable-guest-agent
    ]
    args << (build.with?('sdl') ? '--enable-sdl' : '--disable-sdl')
    ENV['LIBTOOL'] = 'glibtool'
    system "./configure", *args
    system "make install"
  end
end
