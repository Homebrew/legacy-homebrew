require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://dl.dropboxusercontent.com/s/dj86w8ojecgsam7/storm-0.9.0.1.zip'
  sha1 '230abcc15a9e1358442429fd1c856dc12a3be920'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end
