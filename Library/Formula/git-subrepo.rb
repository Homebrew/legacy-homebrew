class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.2.3.tar.gz"
  sha256 "c0db888e841e06ae6f5c74dc9bde4e7ef33ce31b46caeb504885d5b85df1ceef"
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any
    sha256 "18c9f095154cd8d6bfa5154fa4284b5d7b9207e1e3efe8f2f00ffc24a16f9efb" => :yosemite
    sha256 "c5db6617c659c0ba16344e71c5ee56af8e044d7496c2417441ef7165b3cdebea" => :mavericks
    sha256 "e5b2ae1cc7ebbcd2001542b352255865cf562a2855a61ae50c36dc2f4624c019" => :mountain_lion
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
