require 'formula'

class FbClient < Formula
  homepage 'https://paste.xinu.at'
  url 'https://paste.xinu.at/data/client/fb-1.3.0.tar.gz'
  sha1 '4ecf517def1f56a4bfccbea9fc977ce0923566fb'

  conflicts_with 'findbugs',
    :because => "findbugs and fb-client both install a `fb` binary"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
