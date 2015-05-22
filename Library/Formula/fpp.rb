class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.6.0/fpp.0.6.0.tar.gz"
  sha256 "5e3f9e8ffa5e5d0f4608af521458a93010f2f504ce936ac33cf376505099dc65"
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    cellar :any
    sha256 "ae789a874c288492bdf5c7091606a6ceaf19a74a2155995f30da50e61351fa61" => :yosemite
    sha256 "74664af7de31118b6e68391c0d15f7f69c918e0074e05d940e4c83795f60b9a2" => :mavericks
    sha256 "91c376617a259b6d359791d4c6176129f9f1d7e5d515812f325ab739efbabc25" => :mountain_lion
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
