class MrubyCli < Formula
  desc "utility for setting up a CLI with mruby"
  homepage "https://github.com/hone/mruby-cli"
  url "https://github.com/hone/mruby-cli/releases/download/v0.0.4/mruby-cli-0.0.4-x86_64-apple-darwin14.tgz"
  version "0.0.4"
  sha256 "8e434dbca1b5b726469c2d31850271bb640b723a96257f60adc34fd9df972515"

  def install
    bin.install "mruby-cli"
  end

  test do
    system "mruby-cli", " -h"
  end
end
