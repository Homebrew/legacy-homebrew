require "formula"

class Mpdviz < Formula
  homepage "https://github.com/lucy/mpdviz"
  url "http://github.com/neeee/mpdviz/archive/0.4.3.tar.gz"
  sha1 "7923a818155c9fc413e483dcb1b3964ab00e5ded"

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "fftw"

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/lucy/go-fftw"
    system "go", "get", "github.com/lucy/pflag"
    system "go", "get", "github.com/lucy/termbox-go"
    system "go", "build", "-o", "mpdviz"
    bin.install "mpdviz"
  end

end
