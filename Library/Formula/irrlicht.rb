class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "http://irrlicht.sourceforge.net/"
  head "https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk"
  url "https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.1.zip"
  sha256 "814bb90116d5429449ba1d169e2cbff881c473b7eada4c2447132bc4f4a6e97b"

  # may be removed when https://sourceforge.net/p/irrlicht/patches/297/ applied
  head do
    patch do
      url "https://gist.githubusercontent.com/neoascetic/7487c936a3c5858ad762/raw/4f572fdca4cd7a3ae4bb3893d50821cee48e3236/trunk.diff"
      sha256 "df3ea90cfaec1fc2887a2335706bb58b0ccca6258ddb2878f1e159086a3e1abf"
    end
  end

  stable do
    patch do
      url "https://gist.githubusercontent.com/neoascetic/7487c936a3c5858ad762/raw/2e3ab944c43357d705e270a99a5cd7d1b7e033c1/1.8.1.diff"
      sha256 "78f06879c48ad8d87a2790e75f76df4027ae9ab4f89e5d52bedf3778a1d35d77"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "f3e6427bc2499611b12b5babb907153fdd63c478d9745e59821958644e02f915" => :yosemite
    sha256 "4ef8e3d8f22ed7114223f89b6bc286c3fa9cadb9135d274265f2dce396522d27" => :mavericks
    sha256 "5a68f99034d50ce45afe554a36486be55f435bd6b2ff32c8c0f647a0697b0fbb" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
               "-configuration", "Release",
               "-target", "libIrrlicht.a",
               "SYMROOT=build",
               "-sdk", "macosx#{MacOS.version}"
    lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
    include.install "include" => "irrlicht"
  end
end
