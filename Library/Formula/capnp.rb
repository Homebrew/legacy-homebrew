require 'formula'

class Capnp < Formula
  homepage 'http://kentonv.github.io/capnproto/'
  url 'http://capnproto.org/capnproto-c++-0.3.0.tar.gz'
  sha1 '26152010298db40687bf1b18ff6a438986289a44'

  def install
    ENV.libcxx unless MacOS.clang_version >= "5.0"
    args = ["--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules", "--prefix=#{prefix}"]
    system "./configure", *args
    system "make", "-j6", "check"
    system "make", "install"
  end

  test do
    system "capnp", "--version"
  end
end
