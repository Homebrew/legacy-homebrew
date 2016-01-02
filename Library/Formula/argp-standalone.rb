class ArgpStandalone < Formula
  desc "Standalone version of arguments parsing functions from GLIBC"
  homepage "https://www.lysator.liu.se/~nisse/misc/"
  url "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"
  sha256 "dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be"

  bottle do
    cellar :any
    revision 1
    sha256 "c926ac0ad3b8dbb8c3e08299ade556470f81d3a88eb51dc60e7cfe107da533e8" => :yosemite
    sha256 "789a73a54793c058ee419824d76d603562d56fe6c2bce37c6b5b47f8f0ddce2a" => :mavericks
    sha256 "c1d91ec4ec7f0abee15fa5f58860057d8e8c58e25fd9231107f716bcd5e2a607" => :mountain_lion
  end

  # This patch fixes compilation with Clang.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/b5f0ad3/argp-standalone/patch-argp-fmtstream.h"
    sha256 "5656273f622fdb7ca7cf1f98c0c9529bed461d23718bc2a6a85986e4f8ed1cb8"
  end

  conflicts_with "gpgme", :because => "gpgme picks it up during compile & fails to build"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    lib.install "libargp.a"
    include.install "argp.h"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <argp.h>

      int main(int argc, char ** argv)
      {
        return argp_parse(0, argc, argv, 0, 0, 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-largp", "-o", "test"
    system "./test"
  end
end
