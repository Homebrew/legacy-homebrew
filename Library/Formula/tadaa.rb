require 'formula'

class Tadaa < Formula
  homepage 'https://github.com/cggaurav/tadaa'
  url 'https://github.com/cggaurav/tadaa/archive/1.0.tar.gz'
  sha1 '382489e4ccfcef047eddf08bf9b77d7327e5d851'
  version '1.0'
  depends_on 'commander' => :ruby

  def install
    bin.install 'tadaa.rb' => "tadaa"
  end
end
