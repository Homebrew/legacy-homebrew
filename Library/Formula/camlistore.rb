require 'formula'

class Camlistore < Formula
  homepage 'http://camlistore.org'
  head 'https://camlistore.googlesource.com/camlistore', :using => :git
  url 'https://github.com/bradfitz/camlistore/archive/0.8.tar.gz'
  sha1 '076db79303fe1c62323b9dc0713ef1bfceb286b2'

  bottle do
    sha1 "0e23421d8dcd222bdaebbd9cdd4027f570e9c76d" => :mavericks
    sha1 "2833a6aadcb6b11fe31fc7b8adef4a104dd06023" => :mountain_lion
    sha1 "f72efd9e3c4654a0520b1ecf9991e2a23ea4cdad" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'go' => :build
  depends_on 'sqlite'

  def install
    ENV['GIT_DIR'] = cached_download+".git"

    system "go", "run", "make.go"
    prefix.install "bin/README"
    prefix.install "bin"
  end

  test do
    system bin/"camget", "-version"
  end
end
