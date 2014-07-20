require 'formula'

class LibunwindHeaders < Formula
  homepage 'http://opensource.apple.com/'
  url 'http://opensource.apple.com/tarballs/libunwind/libunwind-35.1.tar.gz'
  sha1 '86908428aaa0ae6cec5038dc6eeb8b64dbb6cd63'

  bottle do
    cellar :any
    sha1 "705028cedd90bb0a71247a7437efb86b26ef10ce" => :mavericks
    sha1 "4feb79bee6a976d025537036e47b33a025901cfd" => :mountain_lion
    sha1 "8f17a4a2c393d78f696cdce464b9c060038cdd84" => :lion
  end

  keg_only :provided_by_osx,
    "This package includes official development headers not installed by Apple."

  def install
    inreplace "include/libunwind.h", "__MAC_10_6", "__MAC_NA" if MacOS.version < :snow_leopard

    if MacOS.version < :leopard
      inreplace "include/libunwind.h", /__OSX_AVAILABLE_STARTING\(__MAC_NA,.*\)/,
        "__attribute__((unavailable))"

      %w[include/libunwind.h include/unwind.h src/AddressSpace.hpp
        src/InternalMacros.h].each do |header|
        inreplace header, "Availability.h", "AvailabilityMacros.h"
      end
    end

    include.install Dir['include/*']
    (include/'libunwind').install Dir['src/*.h*']
    (include/'libunwind/libunwind_priv.h').unlink
  end
end
