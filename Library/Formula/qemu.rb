require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.7.0.tar.bz2'
  sha1 '4b5a21a614207e74a61659f7a6edecad6c31be95'

  head 'git://git.qemu-project.org/qemu.git'

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'
  depends_on 'vde' => :optional
  depends_on 'sdl' => :optional

  def patches
    {:p0 => ['https://trac.macports.org/export/97499%20/trunk/dports/emulators/qemu/files/patch-configure.diff']}
  end

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
    system "make", "V=1", "install"
  end
end
