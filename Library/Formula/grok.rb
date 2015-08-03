class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage "https://github.com/jordansissel/grok"
  url "https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  head "https://github.com/jordansissel/grok.git"

  depends_on "libevent"
  depends_on "pcre"
  depends_on "tokyo-cabinet"

  def install
    system "make", "grok"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
