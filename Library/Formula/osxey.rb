require "formula"

class Osxey < Formula
  homepage "https://github.com/diimdeep/OSXey/"
  url "https://github.com/diimdeep/OSXey/archive/1.2.tar.gz"
  sha1 "1d595d93973abcc171aeb5e62ad9ffef3714afc4"

  def install
    bin.install 'bin/OSXey'
    prefix.install 'Models.txt'
  end

  test do
    system "#{bin}/OSXey"
  end
end
