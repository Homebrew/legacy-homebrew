class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.6.2.tar.gz"
  sha256 "dccb33daa14939d53f43e1d02819ecaa960f10a5a479bee32ea47c6e13569623"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "git-fresh", "-T"
  end
end
