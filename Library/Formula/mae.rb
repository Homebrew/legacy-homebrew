require 'formula'

class Mae < Formula

  url 'https://github.com/MrmacHD/MAE/tarball/0.1'
  sha1 '1646337fa53e0800553d3cfc8232928e1bb20a42'
  head 'https://github.com/MrmacHD/MAE.git'
  homepage 'https://github.com/MrmacHD/MAE'

  depends_on :xcode

  def install
    system "xcodebuild", "-project", "MAE.xcodeproj",
                         "-target", "MAE",
                         "-configuration", "Release",
                         "SYMROOT=build",
                         "DSTROOT=build"
    bin.install "build/Release/mae"
    man1.install "MAE/mae.1"
  end

end
