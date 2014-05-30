require 'formula'

class Mpc < Formula
  homepage 'http://www.musicpd.org/clients/mpc/'
  url 'http://www.musicpd.org/download/mpc/0/mpc-0.25.tar.gz'
  sha1 '000f400ea2e62dd717d3f03c2d78572bc7b2e7e5'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
