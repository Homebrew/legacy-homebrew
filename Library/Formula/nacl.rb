class Nacl < Formula
  desc "Network communication, encryption, decryption, signatures library"
  homepage "https://nacl.cr.yp.to/"
  url "https://hyperelliptic.org/nacl/nacl-20110221.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nacl/nacl_20110221.orig.tar.bz2"
  sha256 "4f277f89735c8b0b8a6bbd043b3efb3fa1cc68a9a5da6a076507d067fc3b3bf8"

  bottle do
    cellar :any
    sha256 "1a823f88d5198805003f87cffd4ffee2de972dc9f0bb6abe040b8e8130e0069d" => :yosemite
    sha256 "652ea5154b7f6a207e7ad4b885fb36f94e042eacbd434e75c5e6b5309eafb0d5" => :mavericks
    sha256 "097a08943e49ffd345460185af1df058711243ace3da4a5bc4bfa7d397ad5757" => :mountain_lion
  end

  def install
    system "./do" # This takes a while since it builds *everything*

    # NaCL has an odd compilation model (software by djb, who'da thunk it?)
    # and installs the resulting binaries in a directory like:
    #    <nacl source>/build/<hostname>/lib/<arch>/libnacl.a
    #    <nacl source>/build/<hostname>/include/<arch>/crypto_box.h
    # etc. Each of these is optimized for the specific hardware it's
    # compiled on.
    #
    # It also builds both x86 and x86_64 copies if your compiler can
    # handle it. Here we only install one copy, based on if you're a
    # 64bit system or not. A --universal could come later though I guess.
    archstr  = Hardware.is_64_bit? ? "amd64" : "x86"
    hoststr  = `hostname | sed 's/\\..*//' | tr -cd '[a-z][A-Z][0-9]'`.strip

    # Don't include cpucycles.h
    include.install Dir["build/#{hoststr}/include/#{archstr}/crypto_*.h"]
    include.install "build/#{hoststr}/include/#{archstr}/randombytes.h"

    # Add randombytes.o to the libnacl.a archive - I have no idea why it's separated,
    # but plenty of the key generation routines depend on it. Users shouldn't have to
    # know this.
    nacl_libdir = "build/#{hoststr}/lib/#{archstr}"
    system "ar", "-r", "#{nacl_libdir}/libnacl.a", "#{nacl_libdir}/randombytes.o"
    lib.install "#{nacl_libdir}/libnacl.a"
  end
end
