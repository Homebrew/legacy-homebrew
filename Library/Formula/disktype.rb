class Disktype < Formula
  desc "Detect content format of a disk or disk image"
  homepage "http://disktype.sourceforge.net/"
  head ":pserver:anonymous:@disktype.cvs.sourceforge.net:/cvsroot/disktype", :using => :cvs
  url "https://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz"
  sha256 "b6701254d88412bc5d2db869037745f65f94b900b59184157d072f35832c1111"

  def install
    system "make"
    bin.install "disktype"
    man1.install "disktype.1"
  end

  test do
    path = testpath/"foo"
    path.write "1234"

    output = shell_output("#{bin}/disktype #{path}")
    assert output.include?("Regular file, size 4 bytes")
  end
end
