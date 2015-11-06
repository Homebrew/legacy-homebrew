<<<<<<< HEAD
class Premake5 < Formula
=======
class Premake < Formula
>>>>>>> abeb20dd82af9ce398885da7d6d346fdb8487910
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha6/premake-5.0.0-alpha6-src.zip"
  sha256 "9c13372699d25824cba1c16a0483507a6a28903e2556ffb148b288c189403aee"

  bottle do
    cellar :any
    sha1 "54ccb106b6abf6c1c76a776cffa82d671ab940a2" => :mavericks
    sha1 "960b64d517b1290608acc950058a71f9e984ad79" => :mountain_lion
    sha1 "271358004f8cd52160bfd45d9e58a59bc3fcb75d" => :lion
  end

  def install
    system "make -C build/gmake.macosx"
    bin.install "bin/release/premake5"
  end
end
