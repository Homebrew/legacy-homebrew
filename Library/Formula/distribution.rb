class Distribution < Formula
  desc "Create ASCII graphical histograms in the terminal"
  homepage "https://github.com/philovivero/distribution"
  url "https://github.com/philovivero/distribution/archive/v1.2.2.tar.gz"
  sha256 "b6bfca0b2a802c179f0a9b3dc12290ac0331f10f7472230e1e664aeff16ebd63"
  head "https://github.com/philovivero/distribution.git"

  bottle :unneeded

  def install
    bin.install "distribution.py" => "distribution"
    doc.install "LICENSE.md", "README.md", "distributionrc", "screenshot.png"
  end

  test do
    (testpath/"test").write "a\nb\na\n"
    `#{bin}/distribution <test 2>/dev/null`.include? "a|2"
  end
end
