require 'formula'

# Source now available on BitBucket:
# http://bitbucket.org/nygard/class-dump
class ClassDump < Formula
  url 'http://www.codethecode.com/download/class-dump-3.3.4.tar.bz2'
  homepage 'http://www.codethecode.com/projects/class-dump/'
  md5 '7ff2211d40904a692ffe1b9e1fe3b12c'

  skip_clean "bin/class-dump"

  def install
    bin.install 'class-dump'
  end
end
