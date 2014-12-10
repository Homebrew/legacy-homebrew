require "formula"

class ReginaRexx < Formula
  homepage "http://regina-rexx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.8.2/Regina-REXX-3.8.2.tar.gz"
  sha1 "aa713faae560c37669b304794af946b59d3ebd7e"

  def install
    ENV.j1 # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
