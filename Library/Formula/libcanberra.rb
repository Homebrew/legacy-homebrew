class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "http://0pointer.de/lennart/projects/libcanberra/"
  url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
  sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

  head "git://git.0pointer.de/libcanberra"

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "pulseaudio" => :optional
  depends_on "gstreamer" => :optional
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional

  # Remove --as-needed and --gc-sections linker flag as it causes linking to fail
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/b2cf078b/libcanberra/patch-configure.diff"
    sha256 "614084839beb507c705d1b8d32f6ad1fa0c8379d6705fb3c866e6d7c5d3cf0b8"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
