class Kanif < Formula
  desc "Cluster management and administration tool"
  homepage "http://taktuk.gforge.inria.fr/kanif/"
  url "https://gforge.inria.fr/frs/download.php/26773/kanif-1.2.2.tar.gz"
  sha256 "3f0c549428dfe88457c1db293cfac2a22b203f872904c3abf372651ac12e5879"

  bottle do
    cellar :any
    sha256 "7fc9517feb23867afe77730cdf28bb386570ccb5368d3b0c6b396214abf07e69" => :yosemite
    sha256 "3c003b7621fdef7d8451c3bab928e5b7bb0db0ff1fbe2c5d83b160a021ef93e6" => :mavericks
    sha256 "86f8813209c51d84889c8d5a3d024137a1bdb6d9e95a68042ab875ee00e396bf" => :mountain_lion
  end

  depends_on "taktuk" => :run

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "taktuk -s -c 'ssh' -l brew",
      shell_output("#{bin}/kash -q -l brew -r ssh")
  end
end
