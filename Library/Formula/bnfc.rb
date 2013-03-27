require 'formula'

class Bnfc < Formula
  homepage 'http://bnfc.digitalgrammars.com/'
  url 'http://bnfc.digitalgrammars.com/download/bnfc-2.5b-mac.gz', :using => :nounzip
  sha1 'ccc9f8972ad61b1a5405c2f1d283aa1d9fd36bb0'

  def install
    system "gzip", "-d", "bnfc-2.5b-mac.gz"
    system "mv", "bnfc-2.5b-mac", "bnfc"
    bin.install "bnfc"
  end
end
