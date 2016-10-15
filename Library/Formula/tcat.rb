require "formula"

class Tcat < Formula
  homepage "http://marcomorain.github.io/tcat/"
  url "https://github.com/marcomorain/tcat/archive/0.1.2.tar.gz"
  sha1 "faac576b32ddc99620fbe5f9fde7f01f5b4a4c28"

  def install
    system "make"
    bin.install "tcat"
  end

  test do
    # The ouput of tcat should be parsable as a time
    # => "2014-03-18T12:52:50+0000 hello"
    # Split on whitespace to get the time section, and ensure that it can be
    # parsed as a time.
    Time.parse(`echo hello | tcat --format "%FT%T%z"`.split.first)
  end
end
