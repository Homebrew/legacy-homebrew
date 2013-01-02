require 'formula'

class Vilistextum < Formula
  url 'http://bhaak.dyndns.org/vilistextum/vilistextum-2.6.9.tar.gz'
  homepage 'http://bhaak.dyndns.org/vilistextum/'
  sha1 'd62fe5213b61c0d0356bb2e60757dd535ac0a82b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
