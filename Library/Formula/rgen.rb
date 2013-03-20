require 'formula'

class Rgen < Formula
  homepage 'https://github.com/wader/rgen'
  url 'https://github.com/wader/rgen.git', :revision => '46dd587cda83ae5d16c9a88bb8177abc0be26406'
  version '0.1'
  head 'https://github.com/wader/rgen.git', :branch => 'master'

  def install
    system "xcodebuild", "-project", "rgen.xcodeproj",
                         "-target", "rgen",
                         "-configuration", "Release",
                         "install",
                         "SYMROOT=build",
                         "DSTROOT=build",
                         "INSTALL_PATH=/bin"
    bin.install "build/bin/rgen"
  end
end
