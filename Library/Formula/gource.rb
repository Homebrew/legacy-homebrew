class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.43/gource-0.43.tar.gz"
  sha256 "85a40ac8e4f5c277764216465c248d6b76589ceac012541c4cc03883a24abde4"
  revision 2

  bottle do
    sha256 "d062abff352d5a192cbe73840c8790e8f608ea62c7438aceb346273384c24559" => :el_capitan
    sha256 "c06d9b4f2e1498a2c6b058ff4218004c0dd56aa64123ba0add3d5d744d699167" => :yosemite
    sha256 "910e7a041667ab60ba79590356617fb5934ad4b43ba57f1783d37632953eeb26" => :mavericks
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
