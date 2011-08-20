require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/4.29/+download/byobu_4.29.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 'f144b2202eebbb19b1fbecde652d77c6'

  depends_on 'newt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end