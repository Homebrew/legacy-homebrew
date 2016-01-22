class Walkmod < Formula
  desc "Java-based project to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-2.2.0-installer.zip"
  sha256 "923a0956bfefef6f083f63a8696ee5019b19d2798692c6d456c1557078ed37d6"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec+"bin/walkmod"
  end

  test do
    system "git", "clone", "--depth", "1", "https://github.com/rpau/walkmod-core.git"
    cd "walkmod-core"
    system bin/"walkmod", "check"
  end
end
