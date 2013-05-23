require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'http://downloads.sourceforge.net/project/geogit/geogit-0.2.0/geogit-cli-app-0.2.0.zip'
  sha1 'd57e4a67a644c15f5415c5c73259a9efb5a0595a'

  def install
    bin.install "bin/geogit"
    bin.install "bin/geogit-console"
    prefix.install "repo"
  end
end
