class Pdfjam < Formula
  homepage "https://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam"
  url "https://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam/pdfjam_208.tgz"
  sha256 "c731c598cfad076c985526ff89cbf34423a216101aa5e2d753a71de119ecc0f3"
  version "2.08"

  depends_on :tex

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "#{bin}/pdfjam", "-h"
  end
end
