require 'formula'

class Capnp < Formula
  homepage 'http://kentonv.github.io/capnproto/'
  url 'http://capnproto.org/capnproto-c++-0.3.0.tar.gz'
  sha1 '26152010298db40687bf1b18ff6a438986289a44'

  fails_with :gcc do
    cause "Cap'n Proto requires C++11 support"
  end

  fails_with :gcc_4_0 do
    cause "Cap'n Proto requires C++11 support"
  end

  fails_with :clang do
    build 425
    cause "Clang 3.2 or newer is required to build Cap'n Proto"
  end

  fails_with :llvm do
    cause "Cap'n Proto requires C++11 support"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end
