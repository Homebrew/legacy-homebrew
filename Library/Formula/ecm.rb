class Ecm < Formula
  desc "Prepare CD image files so they compress better"
  homepage "https://web.archive.org/web/20140227165748/http://www.neillcorlett.com/ecm/"
  url "https://web.archive.org/web/20091021035854/http://www.neillcorlett.com/downloads/ecm100.zip"
  version "1.0"
  sha256 "1d0d19666f46d9a2fc7e534f52475e80a274e93bdd3c010a75fe833f8188b425"

  def install
    system ENV.cc, "-o", "ecm", "ecm.c"
    system ENV.cc, "-o", "unecm", "unecm.c"
    bin.install "ecm", "unecm"
  end
end
