require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'http://downloads.sourceforge.net/project/geogit/geogit-0.3.0/geogit-cli-app-0.3.0.zip'
  sha1 'c01976d4592da0184e5459c264c115577c084ae3'

  def install
    bin.install "bin/geogit"
    bin.install "bin/geogit-console"
    prefix.install "repo"
    man1.install Dir['man/*']
  end
end
