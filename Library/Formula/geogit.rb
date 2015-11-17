class Geogit < Formula
  desc "Distributed version control for geospatial data"
  homepage "http://www.geogit.org"
  url "https://downloads.sourceforge.net/project/geogit/geogit-0.10.0/geogit-cli-app-0.10.0.zip"
  sha256 "b1256a2375aa38b5ba22a83d53f9befd3a7495fea5312884810744a43db77720"

  def install
    bin.install "bin/geogit", "bin/geogit-console"
    prefix.install "repo"
  end
end
