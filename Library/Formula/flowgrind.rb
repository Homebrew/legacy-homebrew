require 'formula'

class Flowgrind < Formula
  homepage 'https://launchpad.net/flowgrind'
  url 'https://launchpad.net/flowgrind/trunk/flowgrind-0.7.5/+download/flowgrind-0.7.5.tar.bz2'
  sha1 '77cccd3a5111a03153de8278d33430f36ef0a92c'

  bottle do
    cellar :any
    sha1 "f9a5f48b1e607f817ee1db496ba0b30e032ffa05" => :yosemite
    sha1 "907e3d3c44355ad85eafa8d4e1b6a9f1b82bca2e" => :mavericks
    sha1 "46ca97683f90cd2e86924b09ab5853ecc5fc2158" => :mountain_lion
  end

  depends_on 'gsl'
  depends_on 'xmlrpc-c'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
