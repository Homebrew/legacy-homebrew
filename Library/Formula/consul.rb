require 'formula'

class Consul < Formula
  homepage 'http://www.consul.io/'
  url 'https://dl.bintray.com/mitchellh/consul/0.1.0_darwin_amd64.zip'
  sha256 '7989af75d1bbd43a4dff8f440c9a0883a4bcd66a52d94534f94e1ed1ae219681'
  version '0.1.0'

  def install
    bin.install 'consul'
  end
end
