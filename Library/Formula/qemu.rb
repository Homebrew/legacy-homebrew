require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.6.1.tar.bz2'
  sha1 'ad3ef3709a8ce3a39bd343aa313cefd033afb561'

  head 'git://git.qemu-project.org/qemu.git'

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'
  depends_on 'vde' => :optional
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
    args << (build.with?('vde') ? '--enable-vde' : '--disable-vde')
    ENV['LIBTOOL'] = 'glibtool'
    system "./configure", *args
    system "make install"
  end
end
