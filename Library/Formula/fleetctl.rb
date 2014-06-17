require 'formula'

class Fleetctl < Formula
  homepage 'https://github.com/coreos/fleet'
  url 'https://github.com/coreos/fleet/archive/v0.5.0.tar.gz'
  sha1 '90fbbba15a595e707d43f74294b82217bab57b07'
  head 'https://github.com/coreos/fleet.git'

  bottle do
    sha1 "f27c9d473cb48d1a66fec798df4dfc9f1cad96e9" => :mavericks
    sha1 "f97e7212091f075757d9f9f7248e09a21601d2bc" => :mountain_lion
    sha1 "14bbce08085b257a3875cc34ec50a88c11960e45" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/fleetctl'
  end
end
