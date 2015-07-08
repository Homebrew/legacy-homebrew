require 'formula'

class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage 'http://ofb.net/~egnor/xml2/'
  url 'http://download.ofb.net/gale/xml2-0.5.tar.gz'
  sha1 'e954311383d053747ae0c224b12dfddb8a1c0e74'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo '<test/>' | \"#{bin}/xml2\""
  end
end
