class GitOpen < Formula
  desc "Open GitHub webpages from a terminal"
  homepage "https://github.com/jeffreyiacono/git-open"
  url "https://github.com/jeffreyiacono/git-open/archive/v1.1.tar.gz"
  sha256 "21b4b8f9394d5315b3790704ecb3bb031bce13a90da4a34af553391641421073"

  bottle :unneeded

  def install
    bin.install "git-open.sh" => "git-open"
  end
end
