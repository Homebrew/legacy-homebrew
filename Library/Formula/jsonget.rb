require 'formula'

class Jsonget < Formula
  homepage 'https://github.com/stvp/jsonget'
  url 'https://github.com/stvp/jsonget/archive/v0.0.2.tar.gz'
  sha1 '84394d4b19336baf1f794487c36dd39858c1e2c3'

  depends_on 'go' => :build

  def install
    system "go build"
    bin.install "jsonget-0.0.2" => "jsonget"
  end
end
