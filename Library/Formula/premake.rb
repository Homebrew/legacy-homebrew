require "formula"

class Premake < Formula
  homepage "http://industriousone.com/premake"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.3/premake-4.3-src.zip"
  sha1 "8f37a3599121580f18b578811162b9b49a2e122f"

  bottle do
    cellar :any
    sha1 "54ccb106b6abf6c1c76a776cffa82d671ab940a2" => :mavericks
    sha1 "960b64d517b1290608acc950058a71f9e984ad79" => :mountain_lion
    sha1 "271358004f8cd52160bfd45d9e58a59bc3fcb75d" => :lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
    sha1 "02472d4304ed9ff66cde57038c17fbd42a159028"
  end

  def install
    unless build.devel?
      # Linking against stdc++-static causes a library not found error on 10.7
      inreplace "build/gmake.macosx/Premake4.make", "-lstdc++-static ", ""
    end
    system "make -C build/gmake.macosx"

    # Premake has no install target, but its just a single file that is needed
    bin.install "bin/release/premake4"
  end
end
