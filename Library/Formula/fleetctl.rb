require 'formula'

class Fleetctl < Formula
  homepage 'https://github.com/coreos/fleet'
  url 'https://github.com/coreos/fleet/archive/v0.5.0.tar.gz'
  sha1 '90fbbba15a595e707d43f74294b82217bab57b07'
  head 'https://github.com/coreos/fleet.git'

  bottle do
    sha1 "8abefa5ff7b326a0e607857ed9138ea67105f66f" => :mavericks
    sha1 "07d9277b0fabe907e138a444a237174cf9c44940" => :mountain_lion
    sha1 "8046e086e35a8beb49fab62deb4841687623cc04" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/fleetctl'
  end
end
