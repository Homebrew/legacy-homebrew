class Launch < Formula
  desc "Command-line launcher for OS X, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/"

  head "https://github.com/nriley/launch.git"

  stable do
    url "https://sabi.net/nriley/software/launch-1.2.2.tar.gz"
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
    cellar :any_skip_relocation
    revision 2
    sha256 "f46796abd639e0bb58b97a8c03c598733ead23768799389c70182e2ebde3d70e" => :el_capitan
    sha256 "dd1295732ee8c5642a70005e5139f606d11f3677b7542a8b772fd164b25551e1" => :yosemite
    sha256 "66516ede076656bf3603fb80b499965f7a8715eead23d56ff38de33077bf816b" => :mavericks
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
