require 'formula'

class SpeedtestCli < Formula
  homepage 'https://github.com/sivel/speedtest-cli'
  url 'https://github.com/sivel/speedtest-cli/archive/v0.2.4.tar.gz'
  sha1 '21f0f80b05f3f05adf9a8802e3cd86caa0325e43'

  def install
    bin.install 'speedtest_cli.py' => 'speedtest_cli'
  end
end
