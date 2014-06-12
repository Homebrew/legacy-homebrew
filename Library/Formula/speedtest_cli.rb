require 'formula'

class SpeedtestCli < Formula
  homepage 'https://github.com/sivel/speedtest-cli'
  url 'https://github.com/sivel/speedtest-cli/archive/v0.2.7.tar.gz'
  sha1 'd4e48594aa9eb4ab5c00a93584c02af0371d3f79'

  def install
    bin.install "speedtest_cli.py" => "speedtest-cli"
    # Previous versions of the formula used "speedtest_cli"
    bin.install_symlink "speedtest-cli" => "speedtest_cli"
    man1.install "speedtest-cli.1"
  end
end
