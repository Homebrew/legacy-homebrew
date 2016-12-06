require 'formula'

class ItunesCli < Formula
  homepage 'https://github.com/TXGruppi/itunes-cli'
  url 'https://github.com/TXGruppi/itunes-cli/archive/itunes-cli-0.0.2.zip'
  version '0.0.2'
  sha1 '79ad86d34ee06e18bf31059beeedeed6b5ee7fa5'

  def install
    system "./install.sh #{prefix}"
  end
end
