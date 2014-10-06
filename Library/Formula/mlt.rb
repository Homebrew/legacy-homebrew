require "formula"

class Mlt < Formula
  homepage "http://www.mltframework.org/"
  url "https://downloads.sourceforge.net/mlt/mlt/mlt-0.9.2.tar.gz"
  sha1 "eb1cdb8a1d9e69512716431054e5da7eb3bedb6d"
  bottle do
    sha1 "8a672be9b09bf79c099755f822afd7837ee715a9" => :mavericks
    sha1 "6fbdbc9c2422836ce659989f096d1670570d1c57" => :mountain_lion
    sha1 "b5804ee50a521ee7f09c82fb3d58947ad4413990" => :lion
  end

  revision 1

  depends_on "pkg-config" => :build

  depends_on "atk"
  depends_on "ffmpeg"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sox"

  depends_on "gtk+" => :optional

  if build.with? "gtk"
    depends_on "pango"
    depends_on "gdk-pixbuf"
  end

  def install

    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec"]

    args << "--disable-gtk" if build.without? "gtk"

    system "./configure", *args

    system "make"
    system "make", "install"
  end
end
