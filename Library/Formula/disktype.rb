class Disktype < Formula
  desc "Detect content format of a disk or disk image"
  homepage "http://disktype.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz"
  sha256 "b6701254d88412bc5d2db869037745f65f94b900b59184157d072f35832c1111"
  head ":pserver:anonymous:@disktype.cvs.sourceforge.net:/cvsroot/disktype", :using => :cvs

  bottle do
    cellar :any_skip_relocation
    sha256 "c1f45dc2bdcec2e3b56741bf03d673f3a99534f851d1c77de59d6832d0f75236" => :el_capitan
    sha256 "cc767e7be270b683021ecb2ef3dd16c77b05e9cdf34ed524c942a89514284f57" => :yosemite
    sha256 "36d5db65030be2813c20d3d9df48ae5f2114ea1a3b4f5fb2db324169a52c3c87" => :mavericks
  end

  def install
    system "make"
    bin.install "disktype"
    man1.install "disktype.1"
  end

  test do
    path = testpath/"foo"
    path.write "1234"

    output = shell_output("#{bin}/disktype #{path}")
    assert_match "Regular file, size 4 bytes", output
  end
end
