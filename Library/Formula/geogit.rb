require "formula"

class Geogit < Formula
  desc "Distributed version control for geospatial data"
  homepage "http://www.geogit.org"
  url "https://downloads.sourceforge.net/project/geogit/geogit-0.10.0/geogit-cli-app-0.10.0.zip"
  sha1 "290652c33995f9cba950b4e1e8514b724115a37d"

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
