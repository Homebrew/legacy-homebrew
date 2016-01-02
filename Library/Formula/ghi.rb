class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.0.4.tar.gz"
  sha256 "6fd0442a4b64a66ee27f0d09caf27bcc117737bd997653b94e8404ef7795f963"
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
