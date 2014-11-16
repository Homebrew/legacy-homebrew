require "formula"

class Chgems < Formula
  homepage "https://github.com/postmodern/chgems#readme"
  url "https://github.com/postmodern/chgems/archive/v0.3.2.tar.gz"
  sha1 "73775a7d57e61ca895ae11cebc028f1ab8150977"
  head "https://github.com/postmodern/chgems.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
