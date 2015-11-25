class Walkmod < Formula
  desc "Java-based project to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-2.0.2-installer.zip"
  sha256 "ba4cdb2962902c13ee793d41b43ffe605f1e2806e8f64b6fb227c65cf4d365b3"

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
