require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-2.0.0.tar.bz2'
  sha1 'cc24a60a93ba697057a67b6a7224b95627eaf1a6'
  revision 1

  head 'git://git.qemu-project.org/qemu.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
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
    args << '--disable-gtk'
    ENV['LIBTOOL'] = 'glibtool'
    system "./configure", *args
    system "make", "V=1", "install"
  end
end
