class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  # homepage/url down since ~May 2015
  homepage "http://libtom.org/?page=features&newsitems=5&whatfile=ltm"
  url "http://libtom.org/files/ltm-0.42.0.tar.bz2"
  mirror "https://distfiles.macports.org/libtommath/ltm-0.42.0.tar.bz2"
  sha256 "7b5c258304c34ac5901cfddb9f809b9b3b8ac7d04f700cf006ac766a923eb217"

  bottle do
    cellar :any
    revision 1
    sha1 "fe3bb489505e96a505676c1cbca5ebc554c8990c" => :yosemite
    sha1 "59fa62fa21fbdb2e938d40cf6171c074db8f2e05" => :mavericks
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
  end
end
