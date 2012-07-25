require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/1.7.28/pngcrush-1.7.28.tar.bz2'
  sha1 '9cac6bd1b88fc24dc08996678e7a9eecb3ecd10c'

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
