class Git182Requirement < Requirement
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
  homepage "https://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.3.tar.gz"
  sha256 "7fb0a4ed4e4c23b7fa9334abfd1894ed5821b73be144d56d67d926e3cd7a1eb5"
  head "https://github.com/johnkeeping/git-integration.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "390d49ad2dc16a2a1167094276cd225a76bd0422afd9ee3ccae3127270edfc1d" => :el_capitan
    sha256 "0a41fd7d3c278edd15c2ba11a0e55dfec44f261a998a8b1392454a7c9a5445f9" => :yosemite
    sha256 "6d98f63e393b56144ea6754593eb6c77a252c6876c72febef273a15440a8e655" => :mavericks
    sha256 "c00c4058c45f75f2c455484c19fc9c761316334e53ae3eb928ddaa140ce1e937" => :mountain_lion
  end

  depends_on "asciidoc" => [:build, :optional]
  depends_on Git182Requirement

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
