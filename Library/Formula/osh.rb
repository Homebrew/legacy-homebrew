require "formula"

class Osh < Formula
  homepage "http://v6shell.org"
  head "https://github.com/JNeitzel/v6shell"
  url "http://v6shell.org/src/osh-20140410.tar.gz"
  sha1 "73d44e5d04504e6af1ffb6e23763ec7f5a40ae1a"

  bottle do
    cellar :any
    sha1 "3d552072c3b4e480ddba423af918d4e2d3d0cc4b" => :mavericks
    sha1 "0f54312ecae702162e4e5326f1561215bee7a775" => :mountain_lion
    sha1 "122f3ff69d9d6660de402047faec79d6adfa9441" => :lion
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
