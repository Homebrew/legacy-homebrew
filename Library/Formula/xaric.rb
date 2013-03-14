require 'formula'

class Xaric < Formula
  homepage 'http://xaric.org/'
  url 'http://xaric.org/software/xaric/releases/xaric-0.13.6.tar.gz'
  sha1 'ed10e395dea29fdf7bbc0d65389d789d7d4ca09b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
