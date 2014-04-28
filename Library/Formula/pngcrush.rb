require 'formula'

# Stay at least one version behind and use the old-versions directory, because
# tarballs are routinely removed and upstream won't change this practice.
class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://sourceforge.net/projects/pmt/files/pngcrush/old-versions/1.7/1.7.71/pngcrush-1.7.71.tar.gz'
  sha1 '0ffbf485a2d907807bef8d397adceba1a438096b'

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
