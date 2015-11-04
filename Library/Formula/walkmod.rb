class Walkmod < Formula
  desc "Java-based project to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-2.0-installer.zip"
  sha256 "06f11d9c4acfe3e3e0d20316a49ad613cbd526368308c68670ce749b472fc35f"

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
