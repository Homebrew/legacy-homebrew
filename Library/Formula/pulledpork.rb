class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/0.7.2.tar.gz"
  sha256 "f4b72d03d1ae509049d771fe646c421ec1a877a4a07addc5f6046a3d614e4be7"

  head "https://github.com/shirkdog/pulledpork.git", :branch => "master"

  bottle :unneeded

  depends_on "Switch" => :perl
  depends_on "Crypt::SSLeay" => :perl

  def install
    bin.install "pulledpork.pl"
    doc.install Dir["doc/*"]
    etc.install Dir["etc/*"]
  end
end
