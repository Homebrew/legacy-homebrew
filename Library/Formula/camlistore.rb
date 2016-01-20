class Camlistore < Formula
  desc "Content-addressable multi-layer indexed storage"
  homepage "https://camlistore.org"
  url "https://github.com/camlistore/camlistore.git",
      :tag => "0.9",
      :revision => "7b78c50007780643798adf3fee4c84f3a10154c9"
  head "https://camlistore.googlesource.com/camlistore", :using => :git

  bottle do
    revision 1
    sha256 "c2b76a901e3b55b59665099acb35d72ed7e4710add538238fa6fef149e536d4a" => :yosemite
    sha256 "ed1b23e31324d8c3d6b50f080c37e9357acfb4fd52517057c29b9a75cf2de179" => :mavericks
    sha256 "b180cf6c719435db63e82ba60483c443b002e9f2cbb93fa812d57ce5d9176bf8" => :mountain_lion
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
