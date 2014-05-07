require 'formula'

class Fleetctl < Formula
  homepage 'https://github.com/coreos/fleet'
  url 'https://github.com/coreos/fleet/archive/v0.3.0.tar.gz'
  sha1 'fcce42bca624541f890d5ac61c79fd60a0718407'
  head 'https://github.com/coreos/fleet.git'

  bottle do
    sha1 "486d83a0cee1d7b5c62b554f5197bd3273a7ce49" => :mavericks
    sha1 "c62b2821349c898cf03d786b3e75bbb52a291935" => :mountain_lion
    sha1 "414335309df919f7adf9abe92855d74d63dbb7e5" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/fleetctl'
  end
end
