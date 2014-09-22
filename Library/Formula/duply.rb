require "formula"

class Duply < Formula
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.9.x/duply_1.9.0.tgz"
  sha1 "b195a59523c95424af5393483ae70df2b9267003"

  depends_on "duplicity"

  def install
    bin.install "duply"
  end
end
