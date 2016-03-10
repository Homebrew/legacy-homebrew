class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.5.tar.gz"
  sha256 "bf22226a4488355a7001a5dabbd1e8e3b7e7645efd1519274b956fcb8bcff086"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2b9d5528732044e5ba1793220493542967b8e09b7a4cdff1c842c9c18d980731" => :el_capitan
    sha256 "99bdf1b296de53f9aa8f94e441f38d5994096d5daa1bb615f579e75c3037f186" => :yosemite
    sha256 "3cced176f22ecb811112948fb175408ce106ee7fa74e2c152915893bb9e27ddb" => :mavericks
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    result = shell_output("#{bin}/abduco -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^abduco-#{version}/, result
  end
end
