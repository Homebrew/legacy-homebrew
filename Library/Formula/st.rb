require 'formula'

class St < Formula
  homepage 'https://github.com/nferraz/st'
  url 'https://github.com/nferraz/st/archive/v1.1.1.tar.gz'
  sha1 'ad7fd987b8c986a9ff80a1f65faad7ce6fbb56fa'

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
  end
end
