require 'formula'

class Mpc < Formula
  homepage 'http://www.musicpd.org/clients/mpc/'
  url 'http://www.musicpd.org/download/mpc/0/mpc-0.27.tar.gz'
  sha1 '256926aa3ff8e9665a757d575bb962c094e4c352'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
