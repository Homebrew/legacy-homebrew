class Sbuild < Formula
  homepage "http://sbuild.org"
  url "http://sbuild.org/uploads/sbuild/0.7.6/sbuild-0.7.6-dist.zip"
  sha256 "64e17df4db26980170e5cf616d015924da01f232c5207f2bdc7ba10e7d976e3d"

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system bin/"sbuild", "--help"
  end
end
