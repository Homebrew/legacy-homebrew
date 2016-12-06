require 'formula'

class Yafc < Formula
  homepage 'http://www.yafc-ftp.com/'
  url 'http://www.yafc-ftp.com/upload/yafc-1.2.5.tar.xz'
  sha1 'b8156689f92a5d9b684180394f1763500a25c1a5'

  depends_on 'xz'
  depends_on 'readline'  # we get a compilation error with system readline

  def install
    system "./configure", "--prefix=#{prefix}",
           "--with-readline="+Formula.factory('readline').opt_prefix
    system "make", "install"
  end

  test do
    # Prints version information on stdout and exits with success
    system "yafc -V"
  end
end
