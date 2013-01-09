require 'formula'

class Mpssh < Formula
  homepage 'https://github.com/ndenev/mpssh'
  url 'https://github.com/ndenev/mpssh/archive/1.3.1.tar.gz'
  sha1 'c9ae08c1449962a0585e9cbf5e6174581912a053'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "mpssh"
    man1.install "mpssh.man" => "mpssh.1"
  end

  def test
    system "#{bin}/mpssh"
  end
end
