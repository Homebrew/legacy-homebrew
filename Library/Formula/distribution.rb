class Distribution < Formula
  desc "Create ASCII graphical histograms in the terminal"
  homepage "https://github.com/philovivero/distribution"
  url "https://github.com/philovivero/distribution/archive/v1.2.1.tar.gz"
  sha256 "5f6bea7da09eb47f7f9e9db5ae90db5bcfd67974efbaa984bbe25be458ea151f"
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
