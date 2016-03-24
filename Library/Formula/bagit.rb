class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/releases/download/v4.12.0/bagit-4.12.0.zip"
  sha256 "045efaff7375af8cb47c9dc7890bf17d4d49d149e4d3ac388862288087505695"

  bottle :unneeded

  def install
    # put logs in var, not in the Cellar
    (var/"log/bagit").mkpath
    inreplace "conf/log4j.properties", "${app.home}/logs", "#{var}/log/bagit"

    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/bagit"
  end

  test do
    system bin/"bagit"
  end
end
