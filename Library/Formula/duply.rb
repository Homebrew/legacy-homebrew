class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/1.11.x/duply_1.11.2.tgz"
  sha256 "06843960ae5753395cb5be72a9c9f2fe78e6ea81a17c6d8d28f2ae49ab50d5aa"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
