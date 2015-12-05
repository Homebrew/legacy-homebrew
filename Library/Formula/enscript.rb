class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "http://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"

  head "git://git.savannah.gnu.org/enscript.git"

  bottle do
    revision 1
    sha256 "e55d3f93f7a4eb89d8007d9c0c49d6b7f52778191f2601da648afff0098a6663" => :el_capitan
    sha256 "d1c1bfc90a9e140a3d257d976729fc9b6e55118a10364ce1e3dc3dd26388edc9" => :yosemite
    sha256 "f2be9be9caeff58dbec3c9abf3ff5554865e6a3ee4db91d156edce8ddf5e666e" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  depends_on "gettext"

  conflicts_with "cspice", :because => "both install `states` binaries"

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
