require "formula"

class Mpdviz < Formula
  homepage "https://github.com/neeee/mpdviz"
  url "http://github.com/neeee/mpdviz/archive/0.4.3.tar.gz"
  version "0.4.3"
  sha1 "7923a818155c9fc413e483dcb1b3964ab00e5ded"

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

end
