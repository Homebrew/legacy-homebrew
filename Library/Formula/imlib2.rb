require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.6/imlib2-1.4.6.tar.bz2'
  sha1 '20e111d822074593e8d657ecf8aafe504e9e2967'
  revision 1

  bottle do
    revision 1
    sha1 "c6cb08c880b91081f247e0ee7f3399c76f1392cf" => :yosemite
    sha1 "452e184ee428ebf3dabd28c81570e04c267540a7" => :mavericks
    sha1 "43617f8bb0c30c7de73dc5f2e07d6f1f10fd8e6c" => :mountain_lion
  end

  deprecated_option "without-x" => "without-x11"

  depends_on 'freetype'
  depends_on 'libpng' => :recommended
  depends_on :x11 => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'jpeg' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x11"

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
