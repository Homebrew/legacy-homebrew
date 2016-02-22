class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.43/gource-0.43.tar.gz"
  sha256 "85a40ac8e4f5c277764216465c248d6b76589ceac012541c4cc03883a24abde4"
  revision 3

  bottle do
    sha256 "cb581cb4c8afafd98dc4fd96f3c87a26ad57519d5ab65267de14b3da5790934a" => :el_capitan
    sha256 "d47030c8dc55a2721257b26cfa2de90f2efa5b3e7d0f3d9ae92c0a1a183846af" => :yosemite
    sha256 "f65a495853061d4515445d1a07d2931a06ce0bb9e6782743d63763d00c2dd878" => :mavericks
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11 => :optional

  depends_on "pkg-config" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  # boost failing on lion
  depends_on :macos => :mountain_lion

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
