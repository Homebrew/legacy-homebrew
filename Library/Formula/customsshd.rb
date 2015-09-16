class Customsshd < Formula
  desc "Passwordless launchd SSHD daemon for OSX UI user session"
  homepage "https://github.com/xfreebird/customsshd"
  url "https://github.com/xfreebird/customsshd/archive/1.0.0.tar.gz"
  sha256 "e473c6855f50e232080360bd520c76bc900d4754692dca482bb38286432df721"
  version "1.0.0"

  def install
    bin.install "customsshd"
  end

  test do
    system "customsshd", "--version"
  end
end
