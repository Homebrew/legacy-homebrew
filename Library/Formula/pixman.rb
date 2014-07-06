require "formula"

class Pixman < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/pixman-0.32.6.tar.gz"
  sha256 "3dfed13b8060eadabf0a4945c7045b7793cc7e3e910e748a8bb0f0dc3e794904"

  bottle do
    cellar :any
    sha1 "60ef712e79cb90762dfb4d3af361b5b5d9a0caac" => :mavericks
    sha1 "b71ef451728c982f8a16edf7d93032a6f8ddbbf6" => :mountain_lion
    sha1 "2c2239c33b62feb61fba0a55cfd19f9d3d7ee443" => :lion
  end

  depends_on "pkg-config" => :build

  keg_only :provided_pre_mountain_lion

  option :universal

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Building with llvm-gcc causes PDF rendering issues in Cairo.
      https://trac.macports.org/ticket/30370
      See Homebrew issues #6631, #7140, #7463, #7523.
      EOS
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk"
    system "make", "install"
  end
end
