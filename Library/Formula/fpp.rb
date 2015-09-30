class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.6.1/fpp.0.6.1.tar.gz"
  sha256 "800a6dcf0cfe55fae9b901b2827f2706ef85812cc4d7d6676dde359c62235428"
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3fe9eeb5cb245bbb9bcc960d953d0fab29d443bfcd518ae9fc346efcb30b4bf" => :el_capitan
    sha256 "81c66eb233cf29c15a198b5adcc7cfda6b306d9c2d38d37401c50a2494795358" => :yosemite
    sha256 "7e86a6be38372bec214594ee10cf19eb2afaad9464a4ee23afde33ed5ae5c430" => :mavericks
    sha256 "eb3e955121c0cab6f567b4b3ba942899be74452be5a56c3f766ea9904bf39d09" => :mountain_lion
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
