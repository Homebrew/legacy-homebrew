require 'formula'

class Bwa < Formula
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.5.9.tar.bz2'
  homepage 'http://bio-bwa.sourceforge.net/'
  md5 '27facf40c92e9af40def844b245ed7db'
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
