class Kanif < Formula
  desc "Cluster management and administration tool"
  homepage "http://taktuk.gforge.inria.fr/kanif/"
  url "http://gforge.inria.fr/frs/download.php/26773/kanif-1.2.2.tar.gz"
  sha256 "3f0c549428dfe88457c1db293cfac2a22b203f872904c3abf372651ac12e5879"

  bottle do
    cellar :any
    sha1 "62cfcf372822b0b17e74e4eddafb775a3cd0b43f" => :yosemite
    sha1 "4f75cca495144043a4106ca4f51367cc2a01fa3d" => :mavericks
    sha1 "8ae0a32afdad9dd6b4fa83af7a9587c760b41b5e" => :mountain_lion
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
