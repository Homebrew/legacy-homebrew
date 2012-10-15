require 'formula'

class Ripmime < Formula
  url 'http://www.pldaniels.com/ripmime/ripmime-1.4.0.9.tar.gz'
  homepage 'http://www.pldaniels.com/ripmime/'
  sha1 '883fbed480807c2425965f1c1a96d4c207ae8634'

  def install
    system "make"

    # Don't "make install", do it manually
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
