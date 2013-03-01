require 'formula'

class Mpck < Formula
  homepage 'http://checkmate.gissen.nl/'
  url 'http://checkmate.gissen.nl/checkmate-0.19.tar.gz'
  sha1 '4d96d65c9ad8c738cb87d197a45938ca955337d6'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
