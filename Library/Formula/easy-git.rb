class EasyGit < Formula
  desc "Wrapper to simplify learning and using git"
  homepage "https://people.gnome.org/~newren/eg/"
  url "https://people.gnome.org/~newren/eg/download/1.7.5.2/eg"
  version "1.7.5.2"
  sha256 "59bb4f8b267261ab3d48c66b957af851d1a61126589173ebcc20ba9f43c382fb"

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
