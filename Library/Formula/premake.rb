class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"

  bottle do
    cellar :any
    sha256 "d57b33a77188b36ad9302906ebdd16b454611ee1dc146b1fc008807347bfb141" => :mavericks
    sha256 "dc7affe6284df57b61d81fe6ba00588c79a2c817f57bff1b5dec1a39cd7e5053" => :mountain_lion
    sha256 "626bcb3c9d5244c91468f07e8705ad1726b3250d3018b0d11392df5374679a28" => :lion
  end

  def install
    system "make -C build/gmake.macosx"
    bin.install "bin/release/premake4"
  end
end
