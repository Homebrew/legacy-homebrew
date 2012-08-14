require 'formula'

class Naturaldocs < Formula
  homepage 'http://www.naturaldocs.org/'
  url 'http://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/1.52/NaturalDocs-1.52.zip'
  md5 '68e3982acae57b6befdf9e75b420fd80'

  def install
    # Remove Windows files
    rm_rf Dir['*.bat']

    libexec.install Dir['*']
    chmod 0755, libexec+'NaturalDocs'
    bin.install_symlink libexec+'NaturalDocs'
  end
end
