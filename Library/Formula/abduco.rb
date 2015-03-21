class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.4.tar.gz"
  sha1 "ccd576eb57d9481d5f372e31ce84b3020f661b68"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any
    sha1 "2ac0afd13b4465b28e0688809131a5ff0055f2de" => :yosemite
    sha1 "8653786cb86fbfb36fb03af3451e19bb55792cbf" => :mavericks
    sha1 "bd2982595586f67eb747bc287be03fcd5418f4e6" => :mountain_lion
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
