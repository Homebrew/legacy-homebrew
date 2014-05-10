require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'https://downloads.sourceforge.net/project/geogit/geogit-0.8.0/geogit-cli-app-0.8.0.zip'
  sha1 '343df635d61a26f6ff5603cdb1b51d2b062806ff'

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
