require 'formula'

class Naturaldocs < Formula
  url 'http://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/1.52/NaturalDocs-1.52.zip'
  homepage 'http://www.naturaldocs.org/'
  md5 '68e3982acae57b6befdf9e75b420fd80'

  def install
    # Remove batch files
    rm_rf Dir['*.bat']

    # Install
    libexec.install Dir['*']
    chmod 0755, libexec+'NaturalDocs'
    bin.mkpath

    # Symlink binary
    ln_s libexec+'NaturalDocs', bin+'NaturalDocs'
  end
end
