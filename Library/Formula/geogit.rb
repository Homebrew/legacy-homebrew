require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'http://downloads.sourceforge.net/project/geogit/geogit-0.5.0/geogit-cli-app-0.5.0.zip'
  sha1 'ea0f66b48f7fb3f499d0f79c9c1f8715007417b5'

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
