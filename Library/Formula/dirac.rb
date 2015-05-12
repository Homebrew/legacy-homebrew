class Dirac < Formula
  homepage "http://diracvideo.org/"
  url "http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz"
  sha256 "816b16f18d235ff8ccd40d95fc5b4fad61ae47583e86607932929d70bf1f00fd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  fails_with :llvm do
    build 2334
  end

  fails_with :clang do
    cause "build uses compiler flags not known to clang"
  end

  def install
    # BSD cp doesn't have "-d"
    inreplace "doc/Makefile.in", "cp -dR", "cp -R"

    # Homebrew's libtool package installs names with "g" prefixes
    inreplace "bootstrap", /\blibtool/, "glibtool"

    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
