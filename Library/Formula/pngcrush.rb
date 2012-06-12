require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/1.7.27/pngcrush-1.7.27.tar.bz2'
  md5 '582ab2b4c262b8837cc2d30bf7d14f33'

  def install
    # Required to successfully build the bundled zlib 1.2.6
    ENV.append_to_cflags "-DZ_SOLO"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install 'pngcrush'
  end
end
