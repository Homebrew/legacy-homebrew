require 'formula'

class Libotr < Formula
  homepage 'http://www.cypherpunks.ca/otr/'
  url 'http://www.cypherpunks.ca/otr/libotr-4.0.0.tar.gz'
  sha1 '8865e9011b8674290837afcf7caf90c492ae09cc'

  bottle do
    cellar :any
    revision 1
    sha1 "bca1aa0c737cb530a3fd3c0a35c72e944e963a23" => :yosemite
    sha1 "c46f13b234c05c9582a174008a4ef9e62935ac94" => :mavericks
    sha1 "a5b6552c4a4b477a4ddce1c612728a3e58986800" => :mountain_lion
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
