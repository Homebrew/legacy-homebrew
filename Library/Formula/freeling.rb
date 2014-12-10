require "formula"

class Freeling < Formula
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha1 "42dbf7eec6e5c609e10ccc60768652f220d24771"
  revision 2

  bottle do
    cellar :any
    sha1 "9972b1420a2a0cd2ed4f033ee907dad45ca4e63e" => :mavericks
    sha1 "b8450df079deb28b27db17f5da97f7c53d39bbd0" => :mountain_lion
    sha1 "5e853bc28cf164fb78350f69af5ee15da2acc4e9" => :lion
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
