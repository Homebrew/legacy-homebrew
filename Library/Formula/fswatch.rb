class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.8.0/fswatch-1.8.0.tar.gz"
  sha256 "0d4c4f1ad1ef7c3d783bf02ac018447ae77468337082ec90023a7319ed01aa78"

  bottle do
    cellar :any
    sha256 "271b26e0fef0a832a1f88fec9db479f88fbdc754e4aa3bd90d6f5b3d45dbeda9" => :el_capitan
    sha256 "319da373ec3dcf6e6ae72a6aec06c50154311307d7d17b1c9db30c736acd5cab" => :yosemite
    sha256 "eabd9ff48a7e87cc263cabc64851c825a4a2d375d2fc6ce73dc1d824ed21b29c" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
