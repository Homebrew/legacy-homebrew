require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.0.14.tar.gz'
  sha1 'f6826b330668698fca227b3331e2bab564932d7e'

  def install
    system "make"
    bin.install 'unrar'
  end
end
