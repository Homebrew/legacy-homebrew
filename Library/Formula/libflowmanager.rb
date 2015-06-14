require 'formula'

class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage 'http://research.wand.net.nz/software/libflowmanager.php'
  url 'http://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.4.tar.gz'
  sha1 'fba31188c912433d3496bb0249da2a5d029a7b2e'

  bottle do
    cellar :any
    revision 1
    sha1 "9b6193c50e29254bf47838367cad8611e4a2f47e" => :yosemite
    sha1 "0a63e32382390f51c86332c9592ad9cff1789585" => :mavericks
    sha1 "7292b002e1ffff88f0156610253ad52e2d552820" => :mountain_lion
  end

  depends_on 'libtrace'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
