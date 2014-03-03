require 'formula'

class Irrlicht < Formula
  homepage 'http://irrlicht.sourceforge.net/'
  head 'https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk'
  url 'https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.1.zip'
  sha1 '231cd2cf2eefe43bde7c40537ece055a3d6e09cb'

  depends_on :xcode

  def install
    args = %W(-project source/Irrlicht/MacOSX/MacOSX.xcodeproj -configuration Release -target libIrrlicht.a)
    args << 'SYMROOT=build'
    args << '-sdk' << "macosx#{MacOS.version}"
    xcodebuild *args
    lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
    include.install "include" => "irrlicht"
  end
end
