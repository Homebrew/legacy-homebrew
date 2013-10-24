require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.0.11.tar.gz'
  sha1 'dc89913e3022d14740f50607c7bf123d23d0f96d'

  def install
    system "make"
    bin.install 'unrar'
  end
end
