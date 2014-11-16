require "formula"

# The system versions are too old to build ld64
class CctoolsHeaders < Formula
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/cctools/cctools-855.tar.gz"
  sha1 "b6997939aa9f4f3c4ac70ec819e719330dcd7bcb"

  keg_only :provided_by_osx

  resource "headers" do
    url "https://opensource.apple.com/tarballs/xnu/xnu-2422.90.20.tar.gz"
    sha1 "4aa6b80cc0ff6f9b27825317922b51c5f33d5bae"
  end

  def install
    # only supports DSTROOT, not PREFIX
    inreplace "include/Makefile", "/usr/include", "/include"
    system "make", "installhdrs", "DSTROOT=#{prefix}", "RC_ProjectSourceVersion=#{version}"
    # installs some headers we don't need to DSTROOT/usr/local/include
    (prefix/"usr").rmtree

    # ld64 requires an updated mach/machine.h to build
    resource("headers").stage {(include/"mach").install "osfmk/mach/machine.h"}
  end
end
