class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "http://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"

  head "git://git.savannah.gnu.org/enscript.git"

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
