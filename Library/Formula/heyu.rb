require 'formula'

class Heyu < Formula
  homepage 'http://www.heyu.org/'
  url 'http://www.heyu.org/download/heyu-2.11-rc1.tar.gz'
  sha1 'f02fa53b866343f05d57a2ac87c7f7b39c786295'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "false"
  end
end
