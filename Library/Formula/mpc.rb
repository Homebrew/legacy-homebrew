require 'formula'

class Mpc < Formula
  homepage 'http://www.musicpd.org/clients/mpc/'
  url 'http://www.musicpd.org/download/mpc/0/mpc-0.24.tar.gz'
  sha1 'e382a783c7f5d0c9ec75a208606f6ea587c9563e'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
