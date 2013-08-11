require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'http://downloads.sourceforge.net/project/geogit/geogit-0.4.0/geogit-cli-app-0.4.0.zip'
  sha1 '41d87374e96a765da5ddab928b4cef0756ad339c'

  def install
    bin.install "bin/geogit"
    bin.install "bin/geogit-console"
    prefix.install "repo"
    # The 0.4.0 is missing the man package, this may be fixed in a 0.4.1 or later release.
    # man1.install Dir['man/*']
  end
end
