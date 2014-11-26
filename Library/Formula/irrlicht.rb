require 'formula'

class Irrlicht < Formula
  homepage 'http://irrlicht.sourceforge.net/'
  head 'https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk'
  url 'https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.1.zip'
  sha1 '231cd2cf2eefe43bde7c40537ece055a3d6e09cb'

  # may be removed when https://sourceforge.net/p/irrlicht/patches/297/ applied
  head do
    patch do
      url 'https://gist.githubusercontent.com/neoascetic/7487c936a3c5858ad762/raw/4f572fdca4cd7a3ae4bb3893d50821cee48e3236/trunk.diff'
      sha1 '8c891aabaec1c462ae06415002a2eb92d66bbc2f'
    end
  end

  stable do
    patch do
      url 'https://gist.githubusercontent.com/neoascetic/7487c936a3c5858ad762/raw/2e3ab944c43357d705e270a99a5cd7d1b7e033c1/1.8.1.diff'
      sha1 '338a7e931d06ed2e25427d05273b80334f8c215a'
    end
  end

  bottle do
    cellar :any
    sha1 "ebd8a06138f243086d8006b8557bd75136905795" => :mavericks
    sha1 "a8303b5a78b03fe4458b813a197bf82287048905" => :mountain_lion
    sha1 "74bc9b4dbf82d815543b90e7e302a3d51dc78c4f" => :lion
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
