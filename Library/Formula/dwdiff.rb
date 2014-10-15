require "formula"

class Dwdiff < Formula
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.0.9.tgz"
  sha1 "01cb2230b9147347bcfd1770898e435e4a57fa25"
  revision 2

  bottle do
    sha1 "d86c4df0684421132d197d6059ae73c1022b26cc" => :mavericks
    sha1 "3cde7642d439be392e69a939c8a0f16b30ec84b0" => :mountain_lion
    sha1 "4e33875ebc44f65716a6588de2a82e52658b9806" => :lion
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
