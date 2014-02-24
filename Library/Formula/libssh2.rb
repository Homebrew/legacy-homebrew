require 'formula'

class Libssh2 < Formula
  homepage 'http://www.libssh2.org/'
  url 'http://www.libssh2.org/download/libssh2-1.4.3.tar.gz'
  sha1 'c27ca83e1ffeeac03be98b6eef54448701e044b0'

  bottle do
    cellar :any
    sha1 "521d10a3fee016c550a520777b863170814deefd" => :mavericks
    sha1 "c070043e006da160d36f8fd9ff6dabe757181c40" => :mountain_lion
    sha1 "0e7776c9e56b639013d8a50cdc932d8a3f81a150" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
