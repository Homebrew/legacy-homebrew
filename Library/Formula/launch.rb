class Launch < Formula
  desc "Command-line launcher for OS X, in the spirit of `open`"
  homepage "http://web.sabi.net/nriley/software/"

  head "https://github.com/nriley/launch.git"

  stable do
    url "http://sabi.net/nriley/software/launch-1.2.2.tar.gz"
    sha256 "94509ce5b55a768f3f8da9996193ae01baf78f239a4d0fca637735f2684eed87"

    # Upstream commits to fix the build on 10.10+
    # Remove both patches when upgrading to 1.2.3
    patch do
      url "https://github.com/nriley/launch/commit/622fa2db6f185b4d635e22e90fda6b9741033047.diff"
      sha256 "ab8ede8c11ff9af389728439ca8ac2197d8de66c712c4f51f7ef794de73f0498"
    end

    patch do
      url "https://github.com/nriley/launch/commit/d3207d853e04bf312cc47d15f35e8a61633deab4.diff"
      sha256 "24eabf62956d49a4259068a2316b3a03e17598a2137ff3f200f9076cec92f415"
    end
  end

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

    man1.install gzip("launch.1")
    bin.install "build/Deployment/launch"
  end

  test do
    system "#{bin}/launch", "-n", "/"
  end
end
