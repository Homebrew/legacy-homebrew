class Reaver < Formula
  desc "Implements brute force attack to recover WPA/WPA2 passkeys"
  homepage "https://code.google.com/p/reaver-wps/"
  url "https://reaver-wps.googlecode.com/files/reaver-1.4.tar.gz"
  sha256 "add3050a4a05fe0ab6bfb291ee2de8e9b8a85f1e64ced93ee27a75744954b22d"

  # Adds general support for Mac OS X in reaver:
  # http://code.google.com/p/reaver-wps/issues/detail?id=245
  patch do
    url "https://gist.githubusercontent.com/syndicut/6134996/raw/16f1b4336c104375ff93a88858809eced53c1171/reaver-osx.diff"
    sha256 "2a8f791df1f59747724e2645f060f49742a625686427877d9f0f21dc62f811a7"
  end

  def install
    man1.install "docs/reaver.1.gz"
    prefix.install_metafiles "docs"
    cd "src"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    system "make", "install"
  end
end
