class Embryo < Formula
  desc "Version of the original Small abstract machine"
  homepage "https://docs.enlightenment.org/stable/efl/embryo_main.html"
  url "https://download.enlightenment.org/releases/embryo-1.7.10.tar.gz"
  sha256 "d6700ba34d7903f53695246ca3edd3fe463ed1acbadd283219ec9678bc4989a0"

  bottle do
    sha256 "c1030dbef24058dadb1fa7773b8284d38032a01d5839509f157f13416e7643c0" => :el_capitan
    sha256 "079fa2a100ed0e5392ac1fe1bf9ff9262a43e1f1aeaa57326c3edef8979c7f70" => :yosemite
    sha256 "70a2d8e13a3d699349ddb60cecbeeeaff3f82f9d6b827ebc80f984d9115a51b2" => :mavericks
    sha256 "0a600c02ef8aba936e860a9f60cb1188048c9a589e31d8c787ea26d46ca84200" => :mountain_lion
  end

  head do
    url "https://git.enlightenment.org/legacy/embryo.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"

  conflicts_with "efl", :because => "both install `embryo_cc` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
