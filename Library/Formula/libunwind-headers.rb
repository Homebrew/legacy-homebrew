class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/libunwind/libunwind-35.3.tar.gz"
  sha256 "2bcc95553a44fa3edca41993ccfac65ba267830cb37c85dca760b34094722e56"

  bottle do
    cellar :any_skip_relocation
    sha256 "308e12c8084e3dd179e322320d45b7ebf3393b284cbb6a5754ccde9e577ad90e" => :el_capitan
    sha256 "0a920420880c1222c365fb886eaf0cbc215529e7a7be39280520dc770386fe75" => :yosemite
    sha256 "2b4ae1b1a438269ae833a52e73cafd6357b0d30dd5e8eb33ef29271cdc259f7c" => :mavericks
  end

  keg_only :provided_by_osx,
    "This package includes official development headers not installed by Apple."

  def install
    inreplace "include/libunwind.h", "__MAC_10_6", "__MAC_NA" if MacOS.version < :snow_leopard

    if MacOS.version < :leopard
      inreplace "include/libunwind.h", /__OSX_AVAILABLE_STARTING\(__MAC_NA,.*\)/,
        "__attribute__((unavailable))"

      inreplace %w[include/libunwind.h include/unwind.h src/AddressSpace.hpp src/InternalMacros.h],
        "Availability.h", "AvailabilityMacros.h"
    end

    include.install Dir["include/*"]
    (include/"libunwind").install Dir["src/*.h*"]
    (include/"libunwind/libunwind_priv.h").unlink
  end
end
