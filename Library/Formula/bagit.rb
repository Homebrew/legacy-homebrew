class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/releases/download/bagit-4.9.0/bagit-4.9.0-bin.zip"
  sha256 "31b435e965aa6fa0b95943b199194fac42ff8bfd7050319cd4f06c5b183a86e8"

  bottle :unneeded

  def install
    # put logs in var, not in the Cellar
    (var/"log/bagit").mkpath
    inreplace "conf/log4j.properties", "${app.home}/logs", "#{var}/log/bagit"

    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/bag"
  end

  test do
    system bin/"bag"
  end
end
