require 'formula'

class Rolldice < Formula
  homepage 'https://github.com/sstrickl/rolldice'
  url 'https://github.com/sstrickl/rolldice/archive/87319d74206d1e9c8949a4180f975456b0d284dd.zip'
  sha1 'd6dd186e140c4c2c6cccc26dd54dd82b632ee08a'
  version '1.14'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end
end
