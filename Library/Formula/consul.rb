require "formula"

# Consul has multiple components, but as a whole,
# it is a tool for discovering and configuring services in your infrastructure.

class Consul < Formula
  homepage "http://www.consul.io/"
  url "https://dl.bintray.com/mitchellh/consul/0.1.0_darwin_amd64.zip"
  sha1 "08dfd233011e6fe77928b6dd5d0221b5379250ce"
  version "0.1.0"

  def install
    bin.install "consul"
  end
end
