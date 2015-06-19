require 'formula'

class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage 'http://drobilla.net/software/sord/'
  url 'http://download.drobilla.net/sord-0.12.2.tar.bz2'
  sha1 '01def87419beed8bb51a89e50307a22940f1d968'

  bottle do
    cellar :any
    sha256 "0449c8ef3e82a4678978971c13b1f85558ae76290dae8806597f3bb4d0419cca" => :yosemite
    sha256 "e44dcadb2abaae16e108c5b409b531610cf6778ab114e1008d0eba24a76f6dd9" => :mavericks
    sha256 "c9fc9daeadbe4096518ace14a9635118f037360156b229b4e96df04836d8a102" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'serd'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
