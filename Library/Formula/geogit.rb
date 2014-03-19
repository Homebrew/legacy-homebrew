require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'https://downloads.sourceforge.net/project/geogit/geogit-0.7.0/geogit-cli-app-0.7.0.zip'
  sha1 'b98db1e1a4d7e6e1abf2cf8d96ed647d213c1c92'

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
