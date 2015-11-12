class Dvtm < Formula
  desc "Dynamic Virtual Terminal Manager"
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.14.tar.gz"
  sha256 "8a9bb341f8a4c578b839e22d9a707f053a27ae6df15158e16f4fee787e43747a"
  head "git://repo.or.cz/dvtm.git"

  bottle do
    cellar :any
    sha1 "98ec8e4a27a05b0e4fca36b938d40cb77eeb6745" => :yosemite
    sha1 "8d6cd0a89a131cc77f1ef6886247cf8f8b21e5ec" => :mavericks
    sha1 "5a41d7afa914e09c1f8fe51ed19edc12a07f44e0" => :mountain_lion
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "LIBS=-lc -lutil -lncurses", "install"
  end

  test do
    result = shell_output("#{bin}/dvtm -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^dvtm-#{version}/, result
  end
end
