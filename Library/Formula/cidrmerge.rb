class Cidrmerge < Formula
  homepage "http://cidrmerge.sourceforge.net"
  url "https://downloads.sourceforge.net/project/cidrmerge/cidrmerge/cidrmerge-1.5.3/cidrmerge-1.5.3.tar.gz"
  sha256 "21b36fc8004d4fc4edae71dfaf1209d3b7c8f8f282d1a582771c43522d84f088"

  def install
    system "make"
    bin.install "cidrmerge"
  end

  test do
    system "cidrmerge", "-v"
    require "open3"
    Open3.popen3("cidrmerge") do |stdin, stdout, _|
      stdin.write("10.1.1.0/24\n")
      stdin.write("10.1.1.1/32\n")
      stdin.write("192.1.4.5/32\n")
      stdin.write("192.1.4.4/32\n")
      stdin.close
      assert_equal "10.1.1.0/24\n192.1.4.4/31\n", stdout.read
    end
  end
end
