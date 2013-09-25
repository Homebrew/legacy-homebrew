require 'formula'

class Yafc < Formula
  homepage 'http://www.yafc-ftp.com/'
  url 'http://www.yafc-ftp.com/upload/yafc-1.2.5.tar.xz'
  sha1 'b8156689f92a5d9b684180394f1763500a25c1a5'

  depends_on 'xz' => :build
  depends_on 'readline'

  def install
    readline = Formula.factory('readline').opt_prefix
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{readline}"
    system "make", "install"
  end

  test do
    system "#{bin}/yafc", "-V"
  end
end
