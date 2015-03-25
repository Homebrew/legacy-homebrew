class Bbcolors < Formula
  homepage "http://daringfireball.net/projects/bbcolors/"
  url "http://daringfireball.net/projects/downloads/bbcolors_1.0.1.zip"
  sha256 "6ea07b365af1eb5f7fb9e68e4648eec24a1ee32157eb8c4a51370597308ba085"

  def install
    bin.install "bbcolors"
  end

  test do
    (testpath/"Library/Application Support/BBColors").mkpath
    system "#{bin}/bbcolors", "-list"
  end
end
