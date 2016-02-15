class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/1.7.0.tar.gz"
  sha256 "4ec03bd6b02a1d378e29e88658915c8dfe8f839bfa08263f4ef54cf10d4528ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ddfe2965818eacba2224f3245dda1be7f2a93a17a6480fd248008b13aa71030" => :el_capitan
    sha256 "c7d0ca1827a921102c4569316816e6fe37f258d963048916ece4535b1653df34" => :yosemite
    sha256 "6d624c4aa012144957750b6299ef3c12b53f3c7a5996bc1e161b581cb156c87a" => :mavericks
  end

  depends_on "wdiff"
  depends_on "gawk"
  depends_on "binutils" => :recommended
  depends_on "rpm" => :optional
  depends_on "dpkg" => :optional

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system "pkgdiff"
  end
end
