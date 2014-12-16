class Smpeg2 < Formula
  desc "SDL MPEG Player Library"
  homepage "http://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_2_0_0/", :revision => "408"
  head "svn://svn.icculus.org/smpeg/trunk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-sdltest"
    system "make"
    system "make", "install"

    # To avoid a possible conflict with smpeg 0.x
    mv "#{bin}/plaympeg", "#{bin}/plaympeg2"
    mv "#{man1}/plaympeg.1", "#{man1}/plaympeg2.1"
  end

  test do
    system "#{bin}/plaympeg2", "--version"
  end
end
