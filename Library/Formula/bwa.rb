require 'formula'

class Bwa < Formula
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.5.8a.tar.bz2'
  homepage 'http://bio-bwa.sourceforge.net/'
  md5 '4f34d6d1156f7259eb5a3c946f7f59db'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
    end

    system "make"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end
