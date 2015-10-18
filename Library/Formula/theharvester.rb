class Theharvester < Formula
  desc "Gather materials from public sources (for pen testers)"
  homepage "https://code.google.com/p/theharvester/"
  url "https://theharvester.googlecode.com/files/theHarvester-2.2a.tar.gz"
  sha256 "40f118ef783448460aac10f1fca832fac5ac6f9df3777788ae73578580fd7a4b"

  def install
    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    bin.install_symlink libexec/"theHarvester.py" => "theharvester"
  end

  test do
    output = `#{bin}/theharvester -d example.com -l 1 -b google 2>&1`.strip
    assert_match /nobody@example\.com/, output
  end
end
