class Robodoc < Formula
  desc "Source code documentation tool"
  homepage "https://www.xs4all.nl/~rfsber/Robo/index.html"
  url "https://rfsber.home.xs4all.nl/Robo/archives/robodoc-4.99.43.tar.bz2"
  sha256 "3d826424a3957502caacf39951f7805f1d72bb374c0533de7ca1036f306afdc7"

  bottle do
    sha256 "49ec681a5f820a710aeb711b9afca7379d66b785e8647532e0ab44c17d7021d2" => :yosemite
    sha256 "41e93db4dc547dce179ed9b31d4dc003859e11343500cfba8380f7dc2694d476" => :mavericks
    sha256 "3d44b4e4a4c7128d2109901b8c7e251b9a061e6f420898a04c517ebd04e770de" => :mountain_lion
  end

  head do
    url "https://github.com/gumpu/ROBODoc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-f", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp_r Dir["#{doc}/Examples/PerlExample/*"], testpath
    system bin/"robodoc"
  end
end
