require 'formula'

class Mpssh < Formula
  homepage 'https://github.com/ndenev/mpssh'
  url 'http://mpssh.totalterror.net/mpssh-1.3.1.tar.gz'
  sha1 '4d80a07c6057372a98095f6c788efcfe9c3b030b'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "mpssh"
    man1.install "mpssh.man" => "mpssh.1"
  end

  def test
    system "#{bin}/mpssh"
  end
end
