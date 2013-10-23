require 'formula'

class SpeedtestCli < Formula
  homepage 'https://github.com/sivel/speedtest-cli'
  url 'https://github.com/sivel/speedtest-cli/archive/v0.2.2.tar.gz'
  sha1 '19843804bbc2e62375df63749f13d2d2748ecd07'

  def install
    bin.install 'speedtest_cli.py' => 'speedtest_cli'
  end
end
