require 'formula'

class Naturaldocs < Formula
  homepage 'http://www.naturaldocs.org/'
  url 'https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/1.52/NaturalDocs-1.52.zip'
  sha1 '0457bdd60beb2275a1fad414e6ba0a56798a7993'

  def install
    # Remove Windows files
    rm_rf Dir['*.bat']

    libexec.install Dir['*']
    chmod 0755, libexec+'NaturalDocs'
    bin.install_symlink libexec+'NaturalDocs'
  end
end
