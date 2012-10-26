require 'formula'

class Nsq < Formula
  homepage 'https://github.com/bitly/nsq'
  url 'https://github.com/downloads/bitly/nsq/nsq-0.2.15.darwin-amd64.tar.gz'
  version '0.2.15'
  sha1 '01bd5fd879ad46de95f47fd45a9255320d59b256'

  def install
    prefix.install Dir['*']
  end
end
