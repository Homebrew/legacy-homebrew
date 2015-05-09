class Freeling < Formula
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "http://devel.cpl.upc.edu/freeling/downloads/32"
  version "3.1"
  sha256 "e98471ceb3f58afbe70369584d8d316323d13fcc51d09b2fd7f431a3220982ba"
  revision 4

  bottle do
    cellar :any
    sha256 "79c26e7b2e5de6baf7fd420e62cae2eefbf4da35550f234df780a8207973e062" => :yosemite
    sha256 "26f897ffd076f020d0a6e79fe24db04ff3afa65d0027a92e7f99340f19ff45d8" => :mavericks
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
