require 'formula'

class Capnp < Formula
  homepage 'http://kentonv.github.io/capnproto/'
  url 'http://capnproto.org/capnproto-c++-0.3.0.tar.gz'
  sha1 '26152010298db40687bf1b18ff6a438986289a44'

  fails_with :gcc do
    cause "Cap'n Proto requires C++11 support"
  end

  def install
    ENV.libcxx if ENV.compiler == :clang unless MacOS.clang_build_version >= 500
    args = ["--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules", "--prefix=#{prefix}"]
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end
