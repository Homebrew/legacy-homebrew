require "formula"

class Logentries < Formula
  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.3.2.tar.gz"
  sha1 "5085a64e4f3c0119e213e53fa750e7b895f786e5"

  conflicts_with "le", :because => "both install a le binary"

  def install
    bin.install "le"
  end
end
