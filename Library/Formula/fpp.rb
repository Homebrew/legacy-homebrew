class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.5.6/fpp.0.5.6.tar.gz"
  sha256 "c06a8733471074104099a21957f1f391e1d68969c4671443f4a0518314ecc509"
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    cellar :any
    sha256 "cdde3dc4ea8c8929fef9b2abe72279b36ece16d829322d1ea98ff499afc92ee7" => :yosemite
    sha256 "0810055bac7a470b03ecadfba8e4a73d4ac87f264dabba00a36825094b0d60a8" => :mavericks
    sha256 "e399ecf027bb02474c4cddd313f75c6c8123b9d3a4af0d6773a6a2969d07a2b6" => :mountain_lion
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
