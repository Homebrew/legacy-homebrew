require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.5/imlib2-1.4.5.tar.bz2'
  sha1 'af86a2c38f4bc3806db57e64e74dc9814ad474a0'

  option "without-x", "Build without X support"

  depends_on :freetype
  depends_on :libpng => :recommended
  depends_on :x11 if MacOS::X11.installed? or not build.include? "without-x"
  depends_on 'pkg-config' => :build
  depends_on 'jpeg' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.include? "without-x"

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/imlib2_conv", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "imlib2_test.jpg"
  end
end
