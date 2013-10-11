# vim:ts=2 sw=2 expandtab

require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/fbef1ce50c6079f845a2efbcc6c7734ffc7855af.tar.gz'
  sha1 '4e8bb4867256b89756ada8f6774a46f7a37aafa8'
  version 'master'

  def install
    bin.install 'q'
  end
end

