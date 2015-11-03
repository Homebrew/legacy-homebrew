class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha256 "e98471ceb3f58afbe70369584d8d316323d13fcc51d09b2fd7f431a3220982ba"
  revision 5

  bottle do
    cellar :any
    sha256 "eeef36a84e44de191d226f98f9ab4aa75ea0789c0c6856d8a8df7c17c1791eec" => :el_capitan
    sha256 "b727748b411ebee3a0aa062b8f308762caa1a3c71c59ebb23e85d6037f05bd90" => :yosemite
    sha256 "5be5df5bf27f0d6425430d7a4b342aec04efa2adb448ff7e92bd7417021f8186" => :mavericks
  end

  depends_on "boost" => "with-icu4c"
  depends_on "icu4c"
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
    expected = <<-EOS.undent
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{share}/freeling/config/en.cfg", "Hello world").chomp
  end
end
