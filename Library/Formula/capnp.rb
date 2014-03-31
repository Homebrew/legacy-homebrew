require 'formula'

class Capnp < Formula
  homepage 'http://kentonv.github.io/capnproto/'
  url 'http://capnproto.org/capnproto-c++-0.4.1.tar.gz'
  sha1 '18ce1a404c2bf68e6625e44927bfe6b67186cb15'

  # TODO add fails_with statements for FSF GCC
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
