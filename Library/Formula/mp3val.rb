require 'formula'

class Mp3val < Formula
  homepage 'http://mp3val.sourceforge.net/'
  url 'https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz'
  sha1 '19f7506d387f72def2861ec271c5cb4135bd8f5e'

  def install
    system "gnumake -f Makefile.gcc"
    bin.install "mp3val.exe" => "mp3val"
  end
end
