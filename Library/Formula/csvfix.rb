require 'formula'

class Csvfix <Formula
  url 'http://csvfix.googlecode.com/files/csvfix_src_097a.zip'
  homepage 'http://code.google.com/p/csvfix/'
  sha1 'f990ba6676159dc27e0d90aee02d1eb043140c5f'

  def install
    # configure doesn't work with this dist

    system "make lin"
    bin.install Dir['bin/csvfix']
  end
end
