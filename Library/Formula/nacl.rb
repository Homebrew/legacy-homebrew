class Nacl < Formula
  desc "Network communication, encryption, decryption, signatures library"
  homepage "https://nacl.cr.yp.to/"
  url "https://hyperelliptic.org/nacl/nacl-20110221.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nacl/nacl_20110221.orig.tar.bz2"
  sha256 "4f277f89735c8b0b8a6bbd043b3efb3fa1cc68a9a5da6a076507d067fc3b3bf8"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "55af6242b2da64f373ddb2c60a2725b556a945ba7f1c7e9c90f7795bfe42e20e" => :el_capitan
    sha256 "e97604331197c2d4fd013fcab8b68d5ac9627872a3d550afa4920a95ac1cfe5c" => :yosemite
    sha256 "f223d3283ef0003d2693d45d4d83b9e57c85a69ef2da29a38611dae45c649572" => :mavericks
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
