class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  head "https://github.com/ingydotnet/git-subrepo.git"

  stable do
    url "https://github.com/ingydotnet/git-subrepo/archive/0.2.1.tar.gz"
    sha256 "2caa7f7c50af637b2338f0a6051401e6567ee059dc036eff7d859450a56865f1"

    # Allow symbolic linking of git-subrepo script.
    # https://github.com/ingydotnet/git-subrepo/issues/75
    patch do
      url "https://github.com/a1russell/git-subrepo/commit/393adca1ba49a53d01a8192900f500c4ed53fc27.diff"
      sha256 "2ba7666fa5eb34e2e84777e7e9fcd1c4a0248400e1af50b10f670a11494b1e17"
    end
  end

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
