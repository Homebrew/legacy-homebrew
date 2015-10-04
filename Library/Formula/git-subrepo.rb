class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.2.3.tar.gz"
  sha256 "c0db888e841e06ae6f5c74dc9bde4e7ef33ce31b46caeb504885d5b85df1ceef"
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any
    sha256 "36f76d5672fa97915a9836f7cf1c505bbfe6e5a7b81d980f23257f91b1d07aa9" => :yosemite
    sha256 "ef0d2e945a72c4e191e62ec7a423bc032f98ad7831a3dc5b72c3d8108e34ab8c" => :mavericks
    sha256 "e6bbfc45133c83005afbc55e5f8618eb4c6e0cacf2ed76e9e1ea179c0b1c1265" => :mountain_lion
  end

  def install
    mkdir_p libexec
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      assert_match(/cloned into/,
                   shell_output("git subrepo clone ../mod mod"))
    end
  end
end
