require 'formula'

class Liblacewing < Formula
  homepage 'http://lacewing-project.org/'
  url 'https://github.com/udp/lacewing/archive/0.5.2.tar.gz'
  sha1 '6b0fe0ac3d301308f6b42ef0f2ab4f31d10dcc73'

  head 'https://github.com/udp/lacewing.git', :branch => 'master'

  depends_on 'openssl'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

