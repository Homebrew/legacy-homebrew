class Ecm < Formula
  desc "Prepare CD image files so they compress better"
  homepage "https://web.archive.org/web/20140227165748/http://www.neillcorlett.com/ecm/"
  url "https://web.archive.org/web/20091021035854/http://www.neillcorlett.com/downloads/ecm100.zip"
  sha1 "ec8884b547bebee69fa3d2901dbd076f9a84c2ce"
  version "1.0"

  def install
    system ENV.cc, "-o", "ecm", "ecm.c"
    system ENV.cc, "-o", "unecm", "unecm.c"
    bin.install "ecm", "unecm"
  end
end
