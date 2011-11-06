require 'formula'

class S3sync < Formula
  url 'http://s3sync-s3cmd.googlecode.com/svn/trunk/', :revision => '4'
  version '1.2.6'
  homepage 'http://s3sync.net'

  def install
    bin.install Dir['s3sync/*.rb']
    prefix.install Dir['s3sync/*.txt']
    prefix.install Dir['s3sync/*.example']
  end

  def caveats
    "See #{prefix}/README.txt for details of how to set up the correct environment to use s3sync"
  end
end
