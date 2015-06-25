require 'formula'

class VertX < Formula
  desc "Application platform for the JVM"
  homepage 'http://vertx.io/'
  url 'https://dl.bintray.com/vertx/downloads/vert.x-3.0.0-full.tar.gz'
  sha1 '47b0fad8de3e9c175fca9ff70a127facdd0c0cf0'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
