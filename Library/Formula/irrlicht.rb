require 'formula'

class Irrlicht < Formula
  homepage 'http://irrlicht.sourceforge.net/'
  head 'https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk'
  url 'http://downloads.sourceforge.net/irrlicht/irrlicht-1.8.1.zip'
  sha1 '47f073dabf329e102628757bde4520a4d1629028'

  depends_on :xcode

  def install
    system *%W(xcodebuild -project source/Irrlicht/MacOSX/MacOSX.xcodeproj -configuration Release -target libIrrlicht.a)
    lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
    include.install "include" => "irrlicht"
  end
end
