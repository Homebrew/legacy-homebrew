require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'https://github.com/cpputest/cpputest/archive/v3.5.tar.gz'
  sha1 'a774f99f191db77abf48f4d6b64190bc445369c5'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
