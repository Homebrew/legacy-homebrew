require "formula"

class Dwdiff < Formula
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.0.9.tgz"
  sha1 "01cb2230b9147347bcfd1770898e435e4a57fa25"
  revision 2

  bottle do
    sha1 "7f88e50048cd75124feabeefa19ce892d2530895" => :mavericks
    sha1 "7a7ee944533fe44613dcb53bd5baf1a5e2c6efa0" => :mountain_lion
    sha1 "df694f72951f3c441de4150261437c1d5a0d679f" => :lion
  end

  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Remove non-English man pages
    (man+"nl").rmtree
    (man+"nl.UTF-8").rmtree
    (share+"locale/nl").rmtree
  end
end
