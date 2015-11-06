class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"

  bottle do
    cellar :any
    sha1 "54ccb106b6abf6c1c76a776cffa82d671ab940a2" => :mavericks
    sha1 "960b64d517b1290608acc950058a71f9e984ad79" => :mountain_lion
    sha1 "271358004f8cd52160bfd45d9e58a59bc3fcb75d" => :lion
  end

  def install
    system "make -C build/gmake.macosx"
    bin.install "bin/release/premake4"
  end
end
