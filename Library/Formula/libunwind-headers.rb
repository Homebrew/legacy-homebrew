require 'formula'

class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage 'https://opensource.apple.com/'
  url 'https://opensource.apple.com/tarballs/libunwind/libunwind-35.1.tar.gz'
  sha1 '86908428aaa0ae6cec5038dc6eeb8b64dbb6cd63'

  bottle do
    cellar :any
    revision 1
    sha1 "48f3fb9243e6a5cd3255a9bc43755aedde545a5d" => :yosemite
    sha1 "022d85a3a7e2368bd9a3cbc679d69f074534f50f" => :mavericks
    sha1 "260e0407173d01261b9a2cb79ccc73ca92866437" => :mountain_lion
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

    include.install Dir['include/*']
    (include/'libunwind').install Dir['src/*.h*']
    (include/'libunwind/libunwind_priv.h').unlink
  end
end
