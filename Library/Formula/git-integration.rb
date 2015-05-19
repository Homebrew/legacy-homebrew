class SufficientlyRecentGit < Requirement
  fatal true
  default_formula "git"

  satisfy do
    system "git stripspace --comment-lines </dev/null 2>/dev/null"
  end

  def message
    "Your Git is too old.  Please upgrade to Git 1.8.2 or newer."
  end
end

class GitIntegration < Formula
  desc "Manage git integration branches"
  homepage "http://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.3.tar.gz"
  sha1 "fc64f987a2a6b73c61c8a5278d06bcaa46ee9312"

  depends_on "asciidoc" => [:build, :optional]
  depends_on SufficientlyRecentGit

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    (buildpath/"config.mak").write "prefix = #{prefix}"
    system "make", "install"
    if build.with? "asciidoc"
      system "make", "install-doc"
    end
    system "make", "install-completion"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "An initial commit"
    system "git", "checkout", "-b", "branch-a", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-a"
    system "git", "checkout", "-b", "branch-b", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-b"
    system "git", "checkout", "master"
    system "git", "integration", "--create", "integration"
    system "git", "integration", "--add", "branch-a"
    system "git", "integration", "--add", "branch-b"
    system "git", "integration", "--rebuild"
  end
end
