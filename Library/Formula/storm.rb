require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://github.com/downloads/nathanmarz/storm/storm-0.7.1.zip'
  md5 '83dc4d18439ab4e5da230e7e66f98a7a'

  def install
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/storm"]
  end
end
