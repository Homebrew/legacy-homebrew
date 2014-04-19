require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'https://downloads.sourceforge.net/project/geogit/geogit-0.7.1/geogit-cli-app-0.7.1.zip'
  sha1 'c28b3c353db98c7d08847ad4e87ecebcf98e37b5'

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
