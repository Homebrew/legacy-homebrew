class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.0.9.tgz"
  sha1 "01cb2230b9147347bcfd1770898e435e4a57fa25"
  revision 3

  bottle do
    sha256 "e549a381bc4a2440c48598fe20f653ef5d075cbf4e3d0806e387032d94c6d1d4" => :yosemite
    sha256 "98013209fde9b8480b6d8bfc7d7f23165e0c3d2c62304eefe66d23c24bd7cf34" => :mavericks
    sha256 "945eb1520cb19ceaabd2be44575e37efd99ea1db883fe438523eeedfe20b175a" => :mountain_lion
  end

  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    (man/"nl").rmtree
    (man/"nl.UTF-8").rmtree
    (share/"locale/nl").rmtree
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
