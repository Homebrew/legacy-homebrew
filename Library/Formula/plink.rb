require 'formula'

class Plink < Formula
  url 'http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-src.zip'
  homepage 'http://pngu.mgh.harvard.edu/~purcell/plink/'
  sha1 'd41a2d014ebc02bf11e5235292b50fad6dedd407'

  def install
    ENV.deparallelize
    inreplace "Makefile", "SYS = UNIX", "SYS = MAC"
    system "make"
    (share+'plink').install %w{test.map test.ped}
    bin.install "plink"
  end
end
