require 'formula'

class Bagit < Formula
  homepage 'https://github.com/LibraryOfCongress/bagit-java'
  url 'https://github.com/LibraryOfCongress/bagit-java/releases/download/bagit-4.9.0/bagit-4.9.0-bin.zip'
  sha1 '6ca4c2a202ce6c975b130a180cd3bd2dcbe5a756'

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
