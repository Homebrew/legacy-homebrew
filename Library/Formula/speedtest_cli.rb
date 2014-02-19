require 'formula'

class SpeedtestCli < Formula
  homepage 'https://github.com/sivel/speedtest-cli'
  url 'https://github.com/sivel/speedtest-cli/archive/v0.2.5.tar.gz'
  sha1 '429406730fcb82408c67fb0d78767e5553bd769e'

  def install
    bin.install 'speedtest_cli.py' => 'speedtest_cli'
  end
end
