class Smpeg < Formula
  desc "SDL MPEG Player Library"
  homepage "http://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_0_4_5/", :revision => "399"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "gtk+" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-sdl-prefix=#{Formula["sdl"].opt_prefix}
      --disable-dependency-tracking
      --disable-debug
      --disable-sdltest
    ]

    if build.without? "gtk"
      args << "--disable-gtk-player"
      args << "--disable-gtktest"
    end

    # Skip glmovie to avoid OpenGL error
    args << "--disable-opengl-player"

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    # Install script is not +x by default for some reason
    chmod 0755, "./install-sh"
    system "make", "install"

    rm_f "#{man1}/gtv.1" if build.without? "gtk"
  end

  test do
    system "#{bin}/plaympeg", "--version"
  end
end
