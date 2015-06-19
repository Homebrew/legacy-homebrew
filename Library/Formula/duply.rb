require "formula"

class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.9.x/duply_1.9.1.tgz"
  sha1 "b4a53f6ebc207185ae5c0b5f98bf46cf961def1a"

  depends_on "duplicity"

  def install
    bin.install "duply"
  end
end
