class Walkmod < Formula
  desc "Java-based project to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-2.3.0-installer.zip"
  sha256 "ad4f862bd9fac378d0241ca1471271fd6c09f871acb2e04bcc73b627b77d2865"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec+"bin/walkmod"
  end

  test do
    system "git", "clone", "--depth", "1", "https://github.com/walkmod/walkmod-core.git"
    cd "walkmod-core"
    system bin/"walkmod", "check"
  end
end
