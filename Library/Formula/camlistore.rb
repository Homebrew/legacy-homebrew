class Camlistore < Formula
  desc "Content-addressable multi-layer indexed storage"
  homepage "https://camlistore.org"
  url "https://github.com/camlistore/camlistore.git",
      :tag => "0.9",
      :revision => "7b78c50007780643798adf3fee4c84f3a10154c9"
  head "https://camlistore.googlesource.com/camlistore", :using => :git

  bottle do
    sha256 "62564ebc8af7078716c921f5e8b6dd1b6570d731ffc12a008facc8a927c6d0d3" => :el_capitan
    sha256 "e36f8753cd172aed1cb7c538739b7cb20bae6add3b54d9bcf09a6973fa0c7e21" => :yosemite
    sha256 "00e43ede2522c4d4469eb0e01229b3706525b054cd7afe3e97f21fd23d9ab6a2" => :mavericks
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
