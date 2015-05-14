class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.5.6/fpp.0.5.6.tar.gz"
  sha256 "c06a8733471074104099a21957f1f391e1d68969c4671443f4a0518314ecc509"
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    cellar :any
    sha256 "740e47c5a8b65fa0d04de191f6c725e1412d41b446a9ecd42d2db248f056712e" => :yosemite
    sha256 "6babb29cd3e942b1cbba06d2bdb771269080f51461942390d11b706ce1c66468" => :mavericks
    sha256 "2dd1de06a0e03919559f26de97855f1db1a424d7b1c9794db8d63b1dd156401b" => :mountain_lion
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
