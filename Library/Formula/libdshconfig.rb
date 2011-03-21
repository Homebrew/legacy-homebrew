require 'formula'

class Libdshconfig < Formula
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz'
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  md5 'cb9db850231091a3a848e654d9f0806b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
