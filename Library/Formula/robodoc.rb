class Robodoc < Formula
  homepage "http://www.xs4all.nl/~rfsber/Robo/index.html"
  url "http://rfsber.home.xs4all.nl/Robo/archives/robodoc-4.99.43.tar.bz2"
  sha256 "3d826424a3957502caacf39951f7805f1d72bb374c0533de7ca1036f306afdc7"

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
