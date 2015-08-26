class VertX < Formula
  desc "Application platform for the JVM"
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.0.0-full.tar.gz"
  sha256 "005864a9f0a954d83ea639fbb2c1b87a7e5c3cc8b7c93852049e178fd36c2bab"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
