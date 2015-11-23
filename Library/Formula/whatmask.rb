class Whatmask < Formula
  desc "Network settings helper"
  homepage "http://www.laffeycomputer.com/whatmask.html"
  url "http://downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz"
  sha256 "7dca0389e22e90ec1b1c199a29838803a1ae9ab34c086a926379b79edb069d89"

  bottle do
    cellar :any
    sha256 "428a92b2ba5a3f6f39009a7d3a7fc503b4308fadaeddc287b39fd6b5bdddef74" => :yosemite
    sha256 "c07eb39e586dbc2b78b4c8cf8173c701ac654e4db0fd5fe12b3c7f80ee3ef577" => :mavericks
    sha256 "1af978f489425defa0d2c700a50fb140a6ce62274f4ab76530f553b2fba2f6a5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal <<-EOS.undent, shell_output("#{bin}/whatmask /24")

      ---------------------------------------------
             TCP/IP SUBNET MASK EQUIVALENTS
      ---------------------------------------------
      CIDR = .....................: /24
      Netmask = ..................: 255.255.255.0
      Netmask (hex) = ............: 0xffffff00
      Wildcard Bits = ............: 0.0.0.255
      Usable IP Addresses = ......: 254

    EOS
  end
end
