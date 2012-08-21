require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://github.com/downloads/nathanmarz/storm/storm-0.8.0.zip'
  sha1 'a7057603a7de13d1955d4715a17fd8a19df13a13'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end
