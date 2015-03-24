class Createrepo < Formula
  homepage ""
  url "http://createrepo.baseurl.org/download/createrepo-0.10.tar.gz"
  version "0.10"
  sha256 "d5ccd5ed8e7db48e6a4d60c1e415b6fe7e85a357dff28a7a25683dc9bb2b9dc9"

  def install
    system "make", "install"
  end
end
