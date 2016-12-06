require 'formula'

class Libunrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.0.10.tar.gz'
  sha1 'd48c245a58193c373fd2633f40829dcdda33b387'

  def install
    system "make", "lib"
    lib.install "libunrar.so"
  end
end
