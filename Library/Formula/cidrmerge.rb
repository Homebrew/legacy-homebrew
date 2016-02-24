class Cidrmerge < Formula
  desc "CIDR merging with white listing (network exclusion)"
  homepage "http://cidrmerge.sourceforge.net"
  url "https://downloads.sourceforge.net/project/cidrmerge/cidrmerge/cidrmerge-1.5.3/cidrmerge-1.5.3.tar.gz"
  sha256 "21b36fc8004d4fc4edae71dfaf1209d3b7c8f8f282d1a582771c43522d84f088"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e607252679cd1648e6c9f48ebbeaa2379ce089ad87815bd6636e65dcedebc7b" => :el_capitan
    sha256 "20c6f57fc6081c8d27d2e68b81e3d4c5cd68e7c799dc30e076f45ee71b42e69d" => :yosemite
    sha256 "89b2d5b31bd190e0aa8837b84f3a684cf01b4501321e898507e5d8dd809f09d7" => :mavericks
    sha256 "c4d8b6b3a17f6117b9df0c9159cc55b11d060b3abf475cbd1962b35d0ef3292a" => :mountain_lion
  end

  def install
    system "make"
    bin.install "cidrmerge"
  end

  test do
    input = <<-EOS.undent
      10.1.1.0/24
      10.1.1.1/32
      192.1.4.5/32
      192.1.4.4/32
    EOS
    assert_equal "10.1.1.0/24\n192.1.4.4/31\n", pipe_output("#{bin}/cidrmerge", input)
  end
end
