require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.6/imlib2-1.4.6.tar.bz2'
  sha1 '20e111d822074593e8d657ecf8aafe504e9e2967'
  revision 1

  option "without-x", "Build without X support"

  depends_on 'freetype'
  depends_on 'libpng' => :recommended
  depends_on :x11 if build.with? "x"
  depends_on 'pkg-config' => :build
  depends_on 'jpeg' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x"

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/imlib2_conv", "/usr/share/doc/cups/images/cups.png", "imlib2_test.png"
  end
end
