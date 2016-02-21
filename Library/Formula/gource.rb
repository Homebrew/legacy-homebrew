class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.43/gource-0.43.tar.gz"
  sha256 "85a40ac8e4f5c277764216465c248d6b76589ceac012541c4cc03883a24abde4"
  revision 3

  bottle do
    revision 1
    sha256 "e1621696357348d047ce7df64bcf60ffff09270baafdd9a505839b7db3bfac34" => :el_capitan
    sha256 "4443129a6a16a4895f497ce6ea4b27a0ae42e9040be8510b55009acfc174ba9f" => :yosemite
    sha256 "0f78f00141327eed1e62c6c15436960b156d0a841380f8140a63a019ab35ceaf" => :mavericks
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
