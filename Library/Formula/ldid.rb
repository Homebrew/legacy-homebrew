require "formula"

class Ldid < Formula
  homepage "http://gitweb.saurik.com/ldid.git"
  url "git://git.saurik.com/ldid.git", :tag => "v1.1.2"
  version "1.1.2"

  def install
    system "./make.sh"
    bin.install "ldid"
  end
end
