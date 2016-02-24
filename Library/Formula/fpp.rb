class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.7.0/fpp.0.7.0.tar.gz"
  sha256 "41f14991f8b0dc673863d4ee274c69048913927b973f52e58f15aa632a55a381"
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
