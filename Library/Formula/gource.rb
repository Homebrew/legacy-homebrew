class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.43/gource-0.43.tar.gz"
  sha256 "85a40ac8e4f5c277764216465c248d6b76589ceac012541c4cc03883a24abde4"
  revision 1

  bottle do
    sha256 "42545a4bef92eb71b83204f59357d28e74e9d80d5f10673ac5c7317bd32c7e2f" => :el_capitan
    sha256 "f98ddff763524d0d5bc670a31c12229145be613077b250a2af79acd36ee1df0b" => :yosemite
    sha256 "83dd5ace96b12094dfe287d1655072d57e15ed79588b65ff3752e870460f3068" => :mavericks
    sha256 "7107bae161947b07edf8361846fd18d1b77a6a900456ff30ae01f9a9c9db6978" => :mountain_lion
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

  # boost failing on lion
  depends_on :macos => :mountain_lion

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  depends_on "glew"
  depends_on "jpeg"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

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
