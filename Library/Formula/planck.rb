class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "https://github.com/mfikes/planck/archive/1.4.tar.gz"
  sha256 "57e4fdfb3dbb80b20aa71baa40ed03fe845a442d2ddd6ba9e942b4993ed13385"

  bottle do
    cellar :any
    sha256 "e3924b3ec87a2c602aa694637e1cbb91ff6a3f64cd846fa98e00d2c81a9db088" => :yosemite
    sha256 "d22e140fd5c76ead72472b3fa417cc4329ef9d8bee5c0bc118fd84890a05c1e0" => :mavericks
  end

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "'(- 1 1)'"
  end
end
