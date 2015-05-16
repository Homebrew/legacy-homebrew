require 'formula'

class Launch < Formula
  homepage 'http://web.sabi.net/nriley/software/'
  head 'https://github.com/nriley/launch.git'
  url 'http://sabi.net/nriley/software/launch-1.2.2.tar.gz'
  sha1 'd6fabdb495d3395460148bb99341cbf0f1b9d575'

  bottle do
    cellar :any
    sha1 "32c11675ab351420dcb35742f66ae8a7ca987acf" => :mavericks
    sha1 "702b8164d60d13ef3480c98caee053a242193aaf" => :mountain_lion
    sha1 "1166c77e00378087195ad5273685d839dbb9f305" => :lion
  end

  depends_on :xcode => :build

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-configuration", "Deployment", "SYMROOT=build"

    man1.install gzip('launch.1')
    bin.install 'build/Deployment/launch'
  end
end
