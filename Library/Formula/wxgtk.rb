require 'formula'

class Wxgtk < Formula
  homepage 'http://www.wxwidgets.org'
  url "http://downloads.sourceforge.net/project/wxwindows/2.8.12/wxGTK-2.8.12.tar.gz"
  sha1 '56cc7f6622dd6f2fecd43fc210dc1c6cb155b37f'

  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'gtk+'

  def install

    args=[
      "--with-libpng",
      "--with-opengl",
      "--with-libjpeg",
      "--with-libtiff",
      "--with-freetype",
      "--with-zlib",
      "--enable-unicode",
      "--disable-debug",
      "--prefix=#{prefix}",
      "--with-gtk"
    ]
    ENV.append 'LDFLAGS', '-lX11 -lGL -lGLU'

    system "./configure", *args

    system "make install"

    cd "contrib" do
      system "make"
      system "make install"
    end
  end
end
