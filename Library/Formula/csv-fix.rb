require 'formula'

class CsvFix < Formula
  url 'http://csvfix.googlecode.com/files/csvfix_src_097a.zip'
  homepage 'http://code.google.com/p/csvfix/'
  version '0.97a'
  sha1 'f990ba6676159dc27e0d90aee02d1eb043140c5f'

  def install
    system "make lin"
    bin.install 'bin/csvfix'
  end
end
