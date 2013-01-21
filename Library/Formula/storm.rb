require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://dl.dropbox.com/u/133901206/storm-0.8.2.zip'
  sha1 'abb533c90f5b9eeaafb9136670091fc894fce169'

  devel do
    url 'https://dl.dropbox.com/u/133901206/storm-0.9.0-wip13.zip'
    sha1 '1de407b2eef494db3efc7f0d9b3f6e6fe2e28fc2'
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end
