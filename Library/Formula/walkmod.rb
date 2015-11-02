class Walkmod < Formula
  desc "Java-based project to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-2.0-installer.zip"
  sha256 "176eb51a2ea0b9215b21ea2749c393f2d6f574a549f53e19ff64b436d43d07f9"
  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]

    bin.install_symlink libexec+"bin/walkmod"
  end

  test do
    system "git", "clone", "https://github.com/rpau/walkmod-core.git"
    cd "walkmod-core"
    system bin/"walkmod", "check"
  end
end
