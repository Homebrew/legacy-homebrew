class Eina < Formula
  desc "Eina is a core data structure and common utility library"
  homepage "https://docs.enlightenment.org/auto/eina/eina_main.html"
  url "https://download.enlightenment.org/releases/eina-1.7.10.tar.gz"
  sha256 "3f33ae45c927faedf8d342106136ef1269cf8dde6648c8165ce55e72341146e9"

  bottle do
    sha256 "4624c44c02ada4a1bc5a967efb13a2e5602cca01e61e83bfa03d389006bdb852" => :yosemite
    sha256 "dbfcbd09d224c85aa1697d5892bfbe9e9aa03ba153a4aa2f4eb13625555dce68" => :mavericks
    sha256 "6d3680d80b19884486c8379bf7cced4c141b9d7c7bc97c2044cd617343835ed0" => :mountain_lion
  end

  head do
    url "https://git.enlightenment.org/legacy/eina.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
