class Walkmod < Formula
  desc "Java-based project to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-2.0.1-installer.zip"
  sha256 "8790d3a8772db865d8653aff273a680ace8ea918d2afafaafa32f024077d8a93"

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
