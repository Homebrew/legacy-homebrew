require "formula"

class Bap < Formula
  homepage "https://code.google.com/p/bap/"
  head "http://bap.googlecode.com/svn/trunk/"
  sha1 "4893f34d8274af8edd67c9a50bdce5306ce4e58f"

  def install
    inreplace "scanner.l", "int yylineno = 1;", ""
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    bin.install("aex", "bap", "prep")
  end
end
