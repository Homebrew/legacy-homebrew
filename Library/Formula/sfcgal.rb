class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.2.0.tar.gz"
  sha256 "aeab3ddd7b4eff2b9b6b365ca1731de693d7a788914d4190f444ef59dead5a47"

  bottle do
    sha256 "39175d68557f5c7c57cae4bf8a2e582c369fc7802524ca04575635cc83f70177" => :el_capitan
    sha256 "5a6a90bbd1b78cd81d7b9d72b9ee5b360883c9c4acbbad25c63544443883c2e0" => :yosemite
    sha256 "d765a95d58a672eee6ef1330a5f97c062789229e49698ee2be029771f7967764" => :mavericks
    sha256 "c32d2cbf1c530d11470683c9e4d8ae5004325b93474b840359627c0bd543f214" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
