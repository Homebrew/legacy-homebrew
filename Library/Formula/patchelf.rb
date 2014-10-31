require "formula"

class Patchelf < Formula
  homepage "https://nixos.org/patchelf.html"
  url "http://nixos.org/releases/patchelf/patchelf-0.8/patchelf-0.8.tar.bz2"
  sha1 "d0645e9cee6f8e583ae927311c7ce88d29f416fc"

  bottle do
    cellar :any
    sha1 "bf46aa7abe2def28e6291d2353d6f66d76cbd2ab" => :x86_64_linux
  end

  option "with-static", "Link statically"
  option "without-static-libstdc++", "Link libstdc++ dynamically"

  head do
    url "https://github.com/NixOS/patchelf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    # Fix ./configure: line 4: .: filename argument required
    inreplace "configure.ac", "m4_esyscmd([echo -n $(cat ./version)])", version

    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      ("CXXFLAGS=-static" if build.with? "static"),
      ("CXXFLAGS=-static-libgcc -static-libstdc++" if build.with? "static-libstdc++")
    system "make", "install"
  end

  test do
    system "#{bin}/patchelf --version"
  end
end
