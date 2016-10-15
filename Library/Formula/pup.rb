require "formula"

class Pup < Formula
  homepage "https://github.com/EricChiang/pup"
  version "0.2.2"
  url "https://github.com/EricChiang/pup/releases/download/0.2.2/pup_darwin_amd64"
  sha1 "84afef273e71751d13794333799677fa0f251358"

  def install
    bin.install "pup_darwin_amd64" => "pup"
  end

  test do
    expected = %{<p>\n Hello\n</p>}
    actual = %x{echo "<html><body><p>Hello</p></body></html>" | pup p}.strip
    actual == expected
  end
end
