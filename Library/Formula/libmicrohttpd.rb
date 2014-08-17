require "formula"

class Libmicrohttpd < Formula
  homepage "http://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.37.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.37.tar.gz"
  sha1 "20af66ef99ecdbf426828df6256cb9742a5bce59"

  bottle do
    cellar :any
    sha1 "7c9550a8d1d6cc12a6d1909c917c9ac6756968d7" => :mavericks
    sha1 "eb78f899cfeebe8e88ac11978b9130e15dd410ad" => :mountain_lion
    sha1 "33d895cc7b9610b8daf18f800d2c088085fe1d13" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
