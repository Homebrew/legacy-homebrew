require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/1.7.38/pngcrush-1.7.38.tar.gz'
  sha1 'ed156aaa53b1b48fa0d3e32466d0d5512b25a67a'

  option "with-count-colors", "Compile with PNGCRUSH_COUNT_COLORS, enabling color reduction optimizations"

  def install
    # Required to successfully build the bundled zlib 1.2.6
    ENV.append_to_cflags "-DZ_SOLO"
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS" if build.include? "with-count-colors"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install 'pngcrush'
  end
end
