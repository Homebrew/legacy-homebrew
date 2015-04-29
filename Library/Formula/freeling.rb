require "formula"

class Freeling < Formula
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha1 "42dbf7eec6e5c609e10ccc60768652f220d24771"
  revision 3

  bottle do
    cellar :any
    sha256 "34695c6d00f296ef479f096a589601e39b8b39c653fbb1474811fa578754e690" => :yosemite
    sha256 "a4c19c2be7c5e5f6aed48cf352dbcf3e2e298113d714d466f6721d346996fca5" => :mavericks
    sha256 "a25436b7796ce8bcda57f17ec66e5e3eb7563edf2caa2241edc230b4db58e8e4" => :mountain_lion
  end

  depends_on "icu4c"
  depends_on "boost" => "with-icu4c"
  depends_on "libtool" => :build

  def install
    icu4c = Formula["icu4c"]
    libtool = Formula["libtool"]
    ENV.append "LDFLAGS", "-L#{libtool.lib}"
    ENV.append "LDFLAGS", "-L#{icu4c.lib}"
    ENV.append "CPPFLAGS", "-I#{libtool.include}"
    ENV.append "CPPFLAGS", "-I#{icu4c.include}"

    system "./configure", "--prefix=#{prefix}", "--enable-boost-locale"

    system "make", "install"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    system "echo 'Hello world' | #{bin}/analyze -f #{share}/freeling/config/en.cfg | grep -c 'world world NN 1'"
  end
end
