require "formula"

class Mpdviz < Formula
  homepage "https://github.com/neeee/mpdviz"
  url "https://github.com/neeee/mpdviz.git"
  version "0.4.3-1"

  depends_on "fftw"
  depends_on "pkg-config" => :build
  depends_on "go" => :build

  def install
    ENV['GOPATH'] = buildpath
    system 'go', 'get', 'github.com/neeee/go-fftw'
    system 'go', 'get', 'github.com/neeee/pflag'
    system 'go', 'get', 'github.com/neeee/termbox-go'
    system 'go', 'build', '-o', 'mpdviz'
    bin.install 'mpdviz'
  end

  test do
    system bin/"mpdviz", "--help"
  end

end
