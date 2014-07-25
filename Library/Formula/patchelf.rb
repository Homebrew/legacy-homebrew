require "formula"

class Patchelf < Formula
  homepage "https://nixos.org/patchelf.html"
  url "https://github.com/NixOS/patchelf/archive/0.8.tar.gz"
  sha1 "1b1a090fe902285c7b01be9ad2c15af9ff99eced"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Fix ./configure: line 4: .: filename argument required
    inreplace "configure.ac", "m4_esyscmd([echo -n $(cat ./version)])", version

    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/patchelf --version"
  end
end
