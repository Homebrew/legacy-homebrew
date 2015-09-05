class FbClient < Formula
  desc "Shell-script client for http://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-1.5.0.tar.gz"
  sha256 "205514e7ae6d2ce687c05a5f581248d0f06c29c4e8e004f768ba0b54a39ed2f3"

  head "https://git.server-speed.net/users/flo/fb", :using => :git

  bottle do
    cellar :any
    sha256 "bb16ff29baa1d2dbbf51a04b9cf0aa0bb5b7690e2fecd3be880b3138b0d21069" => :yosemite
    sha256 "281f3a5eb5092dcf59ae63f96cb011fe2283c6c94ff421b2ce2d42aa311836ce" => :mavericks
    sha256 "2d16d3c1edfb3544a3eb0ff9e4ddc8ccc93c4532d7adab83dc6f21dcae8706bf" => :mountain_lion
  end

  conflicts_with "findbugs",
    :because => "findbugs and fb-client both install a `fb` binary"

  depends_on "pkg-config" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end
