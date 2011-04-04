require 'formula'

class Cmd < Formula
  url 'https://github.com/downloads/bytecollective/cmd/cmd-0.1.0.tar.gz'
  homepage 'https://github.com/bytecollective/cmd'
  md5 '678a317fa9a4b5b259bd00a5210372ab'
  head 'git://github.com/bytecollective/cmd.git'

  def install
    bin.install Dir['*']
  end
end
