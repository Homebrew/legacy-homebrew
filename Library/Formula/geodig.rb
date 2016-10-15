require "formula"

class Geodig < Formula
  homepage "https://github.com/dutchcoders/geodig"
  url "https://github.com/dutchcoders/geodig/archive/v1.0.0.tar.gz"
  sha1 "488be926d26f67c858f08ed324e26e9bb64b17d3"
  head "https://github.com/dutchcoders/geodig.git"

  bottle do
    sha1 "fb10fc8d9b76f5d922d19ecb3c8cc0378ffdb4af" => :mavericks
    sha1 "7fa6f1f652c74f5047bcccf260a336ad6f9ff6f0" => :mountain_lion
    sha1 "2b7346b6b6991188de60eb1e35459357bad24e3f" => :lion
  end

  depends_on "go" => :build

  def install
    # Prepare for Go build
    ENV["GOPATH"] = buildpath

    # To avoid re-downloading Cayley, symlink its source from the tarball so that Go can find it
    mkdir_p "src/github.com/dutchcoders/"
    ln_s buildpath, "src/github.com/dutchcoders/geodig"

    # Install Go dependencies
    system "go", "get", "github.com/oschwald/maxminddb-golang"

    # Build
    system "go", "build", "-o", "geodig"

    # Install binary and configuration
    bin.install "geodig"
  end

  def post_install
  end
end
