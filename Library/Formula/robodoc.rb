class Robodoc < Formula
  desc "Source code documentation tool"
  homepage "https://www.xs4all.nl/~rfsber/Robo/index.html"
  url "https://rfsber.home.xs4all.nl/Robo/archives/robodoc-4.99.43.tar.bz2"
  sha256 "3d826424a3957502caacf39951f7805f1d72bb374c0533de7ca1036f306afdc7"

  bottle do
    revision 1
    sha256 "54532e8e7629f4eeedbdef400f40997c25558b692755b816f6facc37a4975d4d" => :el_capitan
    sha256 "a5c2794eb7e02c27707aad1bbea593ddc0d21fbf197f6b4313f8d0ba84fb34a5" => :yosemite
    sha256 "cea580dd90f87075879dc722262668deac629673ed22dc1e2e5a6cb52e2439ca" => :mavericks
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
