require "formula"

class Patchelf < Formula
  homepage "https://nixos.org/patchelf.html"
  url "http://nixos.org/releases/patchelf/patchelf-0.8/patchelf-0.8.tar.bz2"
  sha1 "d0645e9cee6f8e583ae927311c7ce88d29f416fc"

  option "with-static-libstdc++", "Link libstdc++ statically"

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
      ("CXXFLAGS=-static-libgcc -static-libstdc++" if build.with? "static-libstdc++")
    system "make", "install"
  end

  test do
    system "#{bin}/patchelf --version"
  end
end
