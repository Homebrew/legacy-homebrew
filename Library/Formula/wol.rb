require 'formula'

class Wol < Formula
  head 'git://github.com/kylef/wol.git'
  homepage 'http://kylefuller.co.uk/'

  def install
    system "make"
    bin.install "bin/wol"
  end
end
