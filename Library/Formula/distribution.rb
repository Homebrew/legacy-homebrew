require "formula"

class Distribution < Formula
  homepage "https://github.com/philovivero/distribution"
  url "https://github.com/philovivero/distribution/archive/v1.2.1.tar.gz"
  sha1 "4a67c601a0250ab33a227abc648866ddcfbae8b9"
  head "https://github.com/philovivero/distribution.git"

  def install
    bin.install "distribution.py" => "distribution"
    doc.install "LICENSE.md", "README.md", "distributionrc", "screenshot.png"
  end

  test do
    (testpath/"test").write "a\nb\na\n"
    `#{bin}/distribution <test 2>/dev/null`.include? "a|2"
  end
end
