require 'formula'

class Mpc < Formula
  homepage 'http://www.musicpd.org/clients/mpc/'
  url 'http://www.musicpd.org/download/mpc/0/mpc-0.26.tar.gz'
  sha1 '56f434a0dae82d88a4bc24e50be7870ca20676a1'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
