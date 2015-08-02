class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "http://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"

  head "git://git.savannah.gnu.org/enscript.git"

  bottle do
    sha256 "614a397d67b4da4447da55f4051840b5e8da0162dea08b837d3c3a95ae144045" => :yosemite
    sha256 "6e6aa80479d9aa46c91a8fe911d6495d71a0902879534f9af00225dbbb53b2cf" => :mavericks
    sha256 "5949992b171a19ecf7dcc6c411a3e46a6e1aa023cbf5fd8eb0ee973f3595af5b" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  depends_on "gettext"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /GNU Enscript #{Regexp.escape(version)}/,
                 shell_output("#{bin}/enscript -V")
  end
end
