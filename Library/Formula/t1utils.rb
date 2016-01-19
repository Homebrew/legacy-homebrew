class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.39.tar.gz"
  sha256 "0faef3e5c4927b38b05ac99ee177b7d7cddbbf5b4452f98b244f684b52b0d4c4"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3bf7bfa976b8d32a652ca5ee32165ab93b02b83189cc8d63698cadad9ebe67d0" => :el_capitan
    sha256 "3966b75f9da837ff1c06c07e7304cadf45f3f0d47a81db00f519fe1c7afbe05d" => :yosemite
    sha256 "dcfef3d4b31408531519e121f0abc243740c73a8ce52e09defdf86a6b73ae3f3" => :mavericks
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
