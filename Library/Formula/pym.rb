class Pym < Formula
  desc "Simple python interpreter manager"
  homepage "https://github.com/c-bata/pym"
  url "https://github.com/c-bata/pym/releases/download/v0.0.3/pym"
  sha256 "5e687a3185d3d1d3d60d5070be4305f551d7acb74efaefb2c86288d213e417e1"
  version "0.0.3"

  def install
    bin.install 'pym'
  end
end

