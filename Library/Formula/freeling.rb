class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha256 "e98471ceb3f58afbe70369584d8d316323d13fcc51d09b2fd7f431a3220982ba"
  revision 4

  bottle do
    cellar :any
    revision 1
    sha256 "4c101b5eb04c7ab1fa08202f17b836eb9481070d030dd72b5e25bbf9be6904c6" => :el_capitan
    sha256 "b921001f29e09759d08fa04ef080117234e6c7a5f0dfd62064eb18b82ae61a42" => :yosemite
    sha256 "1b5ec2f41b3e8f760ecbdc20260d10464f242c7376eed10d7e9c2b07870d19c5" => :mavericks
    sha256 "f32136a520a0991dfb0e8dc4f98685c389bc886360995d40babad96a744f8c79" => :mountain_lion
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
