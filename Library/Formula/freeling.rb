require "formula"

class Freeling < Formula
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha1 "42dbf7eec6e5c609e10ccc60768652f220d24771"
  revision 2

  bottle do
    cellar :any
    sha1 "1e13d29a0680806e3e705d05e372b5acb36ca412" => :mavericks
    sha1 "5e52ce330befbc1d0d2537504ab4b9ecf059d34e" => :mountain_lion
    sha1 "ca50a07860f7d5afd4ac2c8b3673f56094ada7b0" => :lion
  end

  depends_on "icu4c"
  depends_on "boost" => "with-icu"
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
