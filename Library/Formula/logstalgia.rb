class Logstalgia < Formula
  desc "Web server access log visualizer"
  homepage "https://code.google.com/p/logstalgia/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.6/logstalgia-1.0.6.tar.gz"
  sha256 "a81b94742cce64b0b2d1b1683f2f7ac6d06456056f353896153b1b8181855f34"
  revision 1

  bottle do
    sha256 "20b927dd78f1928df830897968d6da6a0daf066130a8ef1c557d24543831595d" => :yosemite
    sha256 "429ab4722b200bf635fdac39a9918c758c585bf9dfa061d6b7e45edb09371f04" => :mavericks
    sha256 "18bfe2a7c25387223f86e368a0f44cab8016c8b31282f1cc40755f899c6dcd58" => :mountain_lion
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "freetype"
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "pcre"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf -f -i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make"
    system "make", "install"
  end
end
