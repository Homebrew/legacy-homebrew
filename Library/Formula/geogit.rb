require 'formula'

class Geogit < Formula
  homepage 'http://www.geogit.org'
  url 'http://downloads.sourceforge.net/project/geogit/geogit-0.4.0/geogit-cli-app-0.4.0.zip'
  sha1 '41d87374e96a765da5ddab928b4cef0756ad339c'

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
