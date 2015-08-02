class Disktype < Formula
  desc "Detect content format of a disk or disk image"
  homepage 'http://disktype.sourceforge.net/'
  head ":pserver:anonymous:@disktype.cvs.sourceforge.net:/cvsroot/disktype", :using => :cvs
  url 'https://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz'
  sha1 '5ccc55d1c47f9a37becce7336c4aa3a7a43cc89c'

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
