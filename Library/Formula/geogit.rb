require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'https://downloads.sourceforge.net/project/geogit/geogit-0.6.0/geogit-cli-app-0.6.0.zip'
  sha1 'c75683a38fdff63be6d3e843b94e92df72e0d740'

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
