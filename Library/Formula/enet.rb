require 'formula'

class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage 'http://enet.bespin.org'
  url 'http://enet.bespin.org/download/enet-1.3.13.tar.gz'
  sha256 'e36072021faa28731b08c15b1c3b5b91b911baf5f6abcc7fe4a6d425abada35c'

  bottle do
    cellar :any
    sha1 "bb8d2a60449d1deb5251dc1442181e7a4d1c766f" => :yosemite
    sha1 "9982f296c3704e09b2053c40675a3d189a58873d" => :mavericks
    sha1 "b7d3c7abd1b3cb3fd9761c58a3afd86ee4f08158" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
