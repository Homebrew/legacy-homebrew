require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://sourceforge.net/projects/pmt/files/pngcrush/1.7.52/pngcrush-1.7.52.tar.gz'
  sha1 'a86f560803304d2bfb10d60f7cde1ff3bc2ac0a0'

  def install
    # Required to successfully build the bundled zlib 1.2.6
    ENV.append_to_cflags "-DZ_SOLO"
    # Required to enable "-cc" (color counting) option (disabled by default since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install 'pngcrush'
  end
end
