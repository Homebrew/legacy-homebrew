class Camlistore < Formula
  desc "Content-addressable multi-layer indexed storage"
  homepage "http://camlistore.org"
  url "https://github.com/camlistore/camlistore/archive/0.8.tar.gz"
  sha256 "61b75708ae25ac4dc1c5c31c1cf8f806ccaafaaacf618caf1aa9d31489fec50f"
  head "https://camlistore.googlesource.com/camlistore", :using => :git

  bottle do
    sha1 "0e23421d8dcd222bdaebbd9cdd4027f570e9c76d" => :mavericks
    sha1 "2833a6aadcb6b11fe31fc7b8adef4a104dd06023" => :mountain_lion
    sha1 "f72efd9e3c4654a0520b1ecf9991e2a23ea4cdad" => :lion
  end

  conflicts_with "hello", :because => "both install `hello` binaries"

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "sqlite"

  def install
    system "go", "run", "make.go"
    prefix.install "bin/README"
    prefix.install "bin"
  end

  test do
    system bin/"camget", "-version"
  end
end
