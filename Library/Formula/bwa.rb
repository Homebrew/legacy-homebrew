require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.5.10.tar.bz2'
  md5 '04962f916f761dc259d9fb2452b46c5d'

  head 'https://github.com/lh3/bwa.git'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end
