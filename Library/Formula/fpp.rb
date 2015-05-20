class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.5.7/fpp.0.5.7.tar.gz"
  sha256 "1293e9510b2d7c1f83320d11cd2f3034545f92daffb6d8de3ee3c8a563972783"
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
