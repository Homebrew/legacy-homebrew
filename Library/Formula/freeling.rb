class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha256 "e98471ceb3f58afbe70369584d8d316323d13fcc51d09b2fd7f431a3220982ba"
  revision 6

  bottle do
    cellar :any
    sha256 "e991520d3d2b561c323074755769e17d2105d25ea950db49915952f6dceb3a10" => :el_capitan
    sha256 "59ece6bc2018545d27c5fce49dc3978aa7fe1d2ac0cea267f9cd088358fe58a3" => :yosemite
    sha256 "4185e107bca9371fa06e1573b91c7be1005f288478542534ee6bff502ed48368" => :mavericks
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
