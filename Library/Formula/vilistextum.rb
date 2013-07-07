require 'formula'

class Vilistextum < Formula
  homepage 'http://bhaak.dyndns.org/vilistextum/'
  url 'http://bhaak.dyndns.org/vilistextum/vilistextum-2.6.9.tar.gz'
  sha1 'd62fe5213b61c0d0356bb2e60757dd535ac0a82b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
