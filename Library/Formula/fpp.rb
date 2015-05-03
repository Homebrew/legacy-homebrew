class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  # TODO -- change away from gh-pages link
  url "https://facebook.github.io/PathPicker/dist/fpp.0.5.0.tar.gz"
  sha256 "634cbd2f501639186561418bf2036529d3995676836378b5865e7130d34733e8"
  head "https://github.com/facebook/pathpicker.git"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    puts buildpath
    # we need to copy the bash file and source python files
    libexec.install Dir["*"]
    # and then symlink the bash file
    bin.install_symlink libexec/"fpp"
  end

  test do
    system bin/"fpp", "--help"
  end
end
