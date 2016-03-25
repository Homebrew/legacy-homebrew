class Polyml < Formula
  desc "Standard ML implementation"
  homepage "http://www.polyml.org"
  url "https://github.com/polyml/polyml/archive/v5.6.tar.gz"
  sha256 "20d7b98ae56fe030c64054dbe0644e9dc02bae781caa8994184ea65a94a0a615"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 "27ef28e7daab282bd024a940b24288f46cdd5113cffc090c1ea4df56c3b39593" => :el_capitan
    sha256 "8f54bb02f692bf1e64de70b9370210e397f1cb42747fd375eb57f28c3e0014f9" => :yosemite
    sha256 "1b6f485f1840b4f8d28978b82902a978030fde47f35fbc81cd6c83d61cf4d5ff" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
