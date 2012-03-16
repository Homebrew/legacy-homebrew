require 'formula'

class Stud < Formula
  url 'https://github.com/bumptech/stud/tarball/a9b5aca962219ef013afaa73fec4676bb7c056a3'
  version '0.3-a9b5aca962'
  homepage 'https://github.com/bumptech/stud'
  md5 '1517e88c8b09cfd7b333b73dcbef428d'

  depends_on 'libev'
  #depends_on 'openssl'

  def install
    system "make PREFIX=#{prefix}"
    system "make install PREFIX=#{prefix}"
  end

  def test
    system "#{bin}/stud -h"
  end
end
