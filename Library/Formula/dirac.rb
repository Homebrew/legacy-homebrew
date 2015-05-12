class Dirac < Formula
  homepage "http://diracvideo.org/"
  url "http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz"
  sha256 "816b16f18d235ff8ccd40d95fc5b4fad61ae47583e86607932929d70bf1f00fd"

  fails_with :llvm do
    build 2334
  end

  def install
    # BSD cp doesn't have "-d"
    inreplace "doc/Makefile.in", "cp -dR", "cp -R"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
