require 'formula'

class WpCli < Formula
  url 'https://github.com/downloads/andreascreten/wp-cli/wp-cli-0.1.zip'
  homepage 'https://github.com/downloads/andreascreten/wp-cli/'
  head 'https://github.com/andreascreten/wp-cli.git'
  md5 'afeb5d8f33b35980a71b37d4718ccd7e'
  version '0.1'

  def install
      prefix.install Dir['*']
      ln_s prefix+'wp-cli/wp', bin+'wp'
  end

  def test
    system "wp"
  end
end