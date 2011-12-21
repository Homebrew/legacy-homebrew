require 'formula'

class Bwa < Formula
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.5.10.tar.bz2'
  homepage 'http://bio-bwa.sourceforge.net/'
  md5 '04962f916f761dc259d9fb2452b46c5d'
  head 'https://github.com/lh3/bwa.git'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
    end

    system "make"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end
