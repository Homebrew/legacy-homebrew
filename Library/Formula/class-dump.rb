require 'formula'

# Source now available on BitBucket:
# http://bitbucket.org/nygard/class-dump
class ClassDump < Formula
  url 'http://www.codethecode.com/download/class-dump-3.3.3.tar.bz2'
  homepage 'http://www.codethecode.com/projects/class-dump/'
  md5 'c07bf04dba96550fd8b995ef7080cfb2'

  skip_clean "bin/class-dump"

  def install
    bin.install 'class-dump'
  end
end
