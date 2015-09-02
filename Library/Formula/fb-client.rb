class FbClient < Formula
  desc "Shell-script client for http://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-1.5.0.tar.gz"
  sha256 "205514e7ae6d2ce687c05a5f581248d0f06c29c4e8e004f768ba0b54a39ed2f3"

  head "https://git.server-speed.net/users/flo/fb", :using => :git

  bottle do
    cellar :any
    sha256 "e79cb5ad494ad2b72c13da145b2ddf49f057a13a8499a9bd9feaddb5da6b9b2d" => :yosemite
    sha256 "e6dd96a901a2fe55a560c5ca5dba219d25a6447f63d655714f9b4638821c288e" => :mavericks
    sha256 "b4bca38efef773ea10969185df3a4db669dd699df1f14883d8d847a6261003f5" => :mountain_lion
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
