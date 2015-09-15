class Walkmod < Formula
  desc "Java-based project to apply code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-1.3.0-installer.zip"
  sha256 "01ea47c99f7d7bffeb0cd0d960fdab4f09a7d51a1e0979c6b4ff71d0aeb049fd"
  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]

    bin.install_symlink libexec+"bin/walkmod"
  end

  test do
    system bin/"walkmod", "--version"
  end
end
