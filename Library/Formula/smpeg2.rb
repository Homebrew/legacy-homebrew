class Smpeg2 < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_2_0_0/", :revision => "408"
  head "svn://svn.icculus.org/smpeg/trunk"

  bottle do
    cellar :any
    sha256 "6031bf704fd0508bb90322dbe77f62580708e3fe77362e3dea6b0691360b686b" => :yosemite
    sha256 "fa5760a0f8ff18f596b0044a0da7562a361904f2520a7406c3681ace8a705950" => :mavericks
    sha256 "fe631e594d91ffa786d7023d7eb2b8b8a25d747a2e227458da26aaf9b935dfc8" => :mountain_lion
  end

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
