class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  url "https://facebook.github.io/PathPicker/dist/fpp.0.5.3.tar.gz"
  sha256 "94b77ef10a128a694f6302ce578a2d07a3fd2892299d341b22be9496abd7277d"
  head "https://github.com/facebook/pathpicker.git"

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
