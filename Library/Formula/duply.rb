class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.9.x/duply_1.9.1.tgz"
  sha256 "e5f11c5a31a55de24cc5101a6429ea3eac14c0d3f0d6dec344b687089845efc5"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
  end
end
