require 'formula'

class CdHit < Formula
  homepage 'http://bioinformatics.org/cd-hit/'
  url 'http://www.bioinformatics.org/downloads/index.php/cd-hit/cd-hit-v4.5.4-2011-03-07.tgz'
  version '4.5.4'
  sha1 '743c4b6ec79b9d5acd1e1171587e96c03e3e3003'

  def install
    system "make"
    system "mkdir -p #{bin}"
    system "make PREFIX=#{bin} install"
  end

  def test
    system "cd-hit 2>&1 |grep -q CD-HIT"
  end
end
