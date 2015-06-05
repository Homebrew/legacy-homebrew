require "formula"

class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.71.tar.gz"
  version "0.73"
  sha256 "1d52a4073c32db9656284b0cfbe7aba72233d33c9317803bf322d1bf3b252382"

  head "https://github.com/xyproto/algernon.git"

  depends_on "go" => :build
  depends_on :hg => :build

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
