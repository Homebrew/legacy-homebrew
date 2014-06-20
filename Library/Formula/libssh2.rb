require 'formula'

class Libssh2 < Formula
  homepage 'http://www.libssh2.org/'
  url 'http://www.libssh2.org/download/libssh2-1.4.3.tar.gz'
  sha1 'c27ca83e1ffeeac03be98b6eef54448701e044b0'
  revision 1

  bottle do
    cellar :any
    sha1 "ae30a9b7c36d826f05a67a8023df0c2189c9f836" => :mavericks
    sha1 "423d1b21b9bedde5483b735238034a404db7dcf6" => :mountain_lion
    sha1 "5b65dc7202920021fe0359116e08c77e75e861b9" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libssl-prefix=#{Formula['openssl'].opt_prefix}",
                          "--with-libz"
    system "make install"
  end
end
