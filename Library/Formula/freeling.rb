class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha256 "e98471ceb3f58afbe70369584d8d316323d13fcc51d09b2fd7f431a3220982ba"
  revision 5

  bottle do
    cellar :any
    revision 1
    sha256 "b324f4b00c5e9a79c2fcb42b2647e4ac1031f711c4b60a59c81db8ee1ff1ff61" => :el_capitan
    sha256 "38072877b598c0a68da4927f7cc42fcef26d848577f91e19b1f7948725982187" => :yosemite
    sha256 "ef9eb1970588a5a1715f67e8fd96456db9ce7a9e7c28a7a19dba63208c0bde3c" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "boost" => "with-icu4c"
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

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
