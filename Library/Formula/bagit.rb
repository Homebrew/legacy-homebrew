require 'formula'

class Bagit < Formula
  homepage 'https://github.com/LibraryOfCongress/bagit-java'
  url 'https://github.com/LibraryOfCongress/bagit-java/releases/download/bagit-4.8.1/bagit-4.8.1-bin.zip'
  sha1 'a5f42372dcbe75f44d9181dd8edc8e6f18b68ec9'

  def install
    # put logs in var, not in the Cellar
    (var/'log/bagit').mkpath
    inreplace "conf/log4j.properties", "${app.home}/logs", "#{var}/log/bagit"

    libexec.install Dir['*']

    bin.install_symlink libexec/"bin/bag"
  end

  test do
    system bin/'bag'
  end
end
