require 'formula'

class Abfind <Formula
  # Can't build from stable tarball
  head "http://iharder.svn.sourceforge.net/svnroot/iharder/abfind/"
  homepage 'http://iharder.sourceforge.net/current/macosx/abfind/'

  def install
    system "xcodebuild"
    bin.install "build/Release/abfind"
  end
end
