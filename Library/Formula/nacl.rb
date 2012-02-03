require 'formula'

class Nacl < Formula
  url 'http://hyperelliptic.org/nacl/nacl-20110221.tar.bz2'
  homepage 'http://nacl.cace-project.eu'
  md5 '7efb5715561c3d10dafd3fa97b4f2d20'

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
    system "ar -r #{nacl_libdir}/libnacl.a #{nacl_libdir}/randombytes.o"
    lib.install "#{nacl_libdir}/libnacl.a"
  end
end
