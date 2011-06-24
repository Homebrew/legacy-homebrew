require 'formula'

class Plink < Formula
  url 'http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-src.zip'
  homepage 'http://pngu.mgh.harvard.edu/~purcell/plink/'
  md5 '4566376791df4e69459b849bd7078fa3'

  def install
    ENV.deparallelize
    inreplace "Makefile", "SYS = UNIX", "SYS = MAC"
    system "make"
    (share+'plink').install %w{test.map test.ped}
    bin.install "plink"
  end
end
