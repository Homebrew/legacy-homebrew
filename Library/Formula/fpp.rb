class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.6.2/fpp.0.6.2.tar.gz"
  sha256 "a437e8d779053cac28f582e8b9f8621bc872af9cd7a0afdce5cdd0912f974513"
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc11342cec78684be0e6f43b8276026fe1f23d6c7e201b0f629ba9a3fd1e1592" => :el_capitan
    sha256 "c79b5dcb7b79fee7b8562d64936894fec85b9b1ac6ae69a313e22e595263691a" => :yosemite
    sha256 "14e13d31f2fee2c5e59cdd7c68e16caffa8b0a51455ac6c2c4282f1221d5383a" => :mavericks
  end

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
