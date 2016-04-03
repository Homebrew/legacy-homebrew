class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.5.tar.gz"
  sha256 "bf22226a4488355a7001a5dabbd1e8e3b7e7645efd1519274b956fcb8bcff086"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2810ca2edcaa1b8eaab028a576e267548af21569002a36f72e2b9253a9c376ff" => :el_capitan
    sha256 "51d6b180c576a7bed2aecf64dc357b25b064540cc41225cc2dd6d94f041a7250" => :yosemite
    sha256 "8d89785db68551d9c53ecf2afb099976b61b7fde76d2eaff34acf18d50b09da0" => :mavericks
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
