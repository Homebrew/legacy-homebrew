require "formula"

class Osh < Formula
  homepage "http://v6shell.org"
  url "http://v6shell.org/src/osh-20140410.tar.gz"
  sha1 "73d44e5d04504e6af1ffb6e23763ec7f5a40ae1a"
  head "https://github.com/JNeitzel/v6shell"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

end
