require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://dl.dropbox.com/u/133901206/storm-0.8.2.zip'
  sha1 'abb533c90f5b9eeaafb9136670091fc894fce169'

  devel do
    url 'https://dl.dropbox.com/u/133901206/storm-0.9.0-wip21.zip'
    sha1 '0007b8feba30a126dce8a97412d440b967cb3d26'
    version '0.9.0-wip21'
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end
