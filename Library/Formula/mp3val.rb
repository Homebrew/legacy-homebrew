require 'formula'

class Mp3val < Formula
  url 'http://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz'
  homepage 'http://mp3val.sourceforge.net/'
  md5 'dc8adad909d0b8734ed22029b2de2cb4'

  def install
    system "gnumake -f Makefile.gcc"
    bin.install "mp3val.exe" => "mp3val"
  end
end
