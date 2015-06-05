class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.74.tar.gz"
  version "0.74"
  sha256 "1341af6864643a968d85bfa63ca231604b6d1123919c6826ae179908c6c4a176"

  head "https://github.com/xyproto/algernon.git"

  depends_on "go" => :build
  depends_on :hg => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "-d"

    # Build and install algernon
    system "go", "build", "-o", "algernon"

    bin.install "algernon"
  end

  test do
    system "#{bin}/algernon", "--version"
  end
end
