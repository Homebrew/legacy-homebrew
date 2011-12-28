require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/tarball/v0.3.0'
  homepage 'https://github.com/sstephenson/rbenv'
  md5 '26e00faff3ba04fdeeeecb0bfbf96351'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end
end
