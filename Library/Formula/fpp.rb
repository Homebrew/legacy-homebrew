class Fpp < Formula
  desc "Alternative to piping that accepts input and presents a UI for selecting items"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.6.0/fpp.0.6.0.tar.gz"
  sha256 "5e3f9e8ffa5e5d0f4608af521458a93010f2f504ce936ac33cf376505099dc65"
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    cellar :any
    sha256 "e99cee3f18c0fee425bb452cec86599ed46f181a337ff6657f38d410058ec725" => :yosemite
    sha256 "d58cb003bb7080570f13cc9251467218b83f0ff8f9cd2889a051c5716d9d0f29" => :mavericks
    sha256 "d199b13c4254f992d56a61b70e2f8ed1f63412950e5c6c0958b6fb524fd55cb2" => :mountain_lion
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
