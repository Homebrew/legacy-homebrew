require "formula"

class Duply < Formula
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.8.x/duply_1.8.0.tgz"
  sha1 "167dfa273021931d7ab6e48c9c515d273b4d3015"

  depends_on "duplicity"

  def install
    bin.install "duply"
  end
end
