class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.6.2/fpp.0.6.2.tar.gz"
  sha256 "a437e8d779053cac28f582e8b9f8621bc872af9cd7a0afdce5cdd0912f974513"
  head "https://github.com/facebook/pathpicker.git"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # we need to copy the bash file and source python files
    libexec.install Dir["*"]
    # and then symlink the bash file
    bin.install_symlink libexec/"fpp"
  end

  test do
    system bin/"fpp", "--help"
  end
end
