require "formula"

class SpeedtestCli < Formula
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v0.3.1.tar.gz"
  sha1 "62ff7ac4fd916996110fec46e74dfc8b25860955"

  def install
    bin.install "speedtest_cli.py" => "speedtest-cli"
    # Previous versions of the formula used "speedtest_cli"
    bin.install_symlink "speedtest-cli" => "speedtest_cli"
    man1.install "speedtest-cli.1"
  end
end
