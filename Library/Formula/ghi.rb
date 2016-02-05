class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.1.0.tar.gz"
  sha256 "90ee10cefe9b83514eadb185b339a7147627c54c508e28f292e56719af6bfcb6"
  head "https://github.com/stephencelis/ghi.git"

  bottle :unneeded

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end
