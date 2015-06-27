class FbClient < Formula
  desc "Shell-script client for http://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-1.4.3.tar.gz"
  sha256 "4466bc6192f525bb9aaee053d7e7637a97da7e751168dda6ecd7debe74f93986"

  bottle do
    cellar :any
    sha256 "e79cb5ad494ad2b72c13da145b2ddf49f057a13a8499a9bd9feaddb5da6b9b2d" => :yosemite
    sha256 "e6dd96a901a2fe55a560c5ca5dba219d25a6447f63d655714f9b4638821c288e" => :mavericks
    sha256 "b4bca38efef773ea10969185df3a4db669dd699df1f14883d8d847a6261003f5" => :mountain_lion
  end

  head "https://git.server-speed.net/users/flo/fb", :using => :git

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
