class Dvtm < Formula
  desc "Dynamic Virtual Terminal Manager"
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.14.tar.gz"
  sha256 "8a9bb341f8a4c578b839e22d9a707f053a27ae6df15158e16f4fee787e43747a"
  head "git://repo.or.cz/dvtm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a49715cb36f2fb6155d44a4d04aba32b2177f5c20cd32a42065c10227600589f" => :el_capitan
    sha256 "5b87346df1de5e39993819a29b5c0c0d831c8044055bc2f2eaf04128439109aa" => :yosemite
    sha256 "d06ea6daaea24641ce1d34e69bcf023611a61d1ea1f7cb23aff6b7add3c7c1c2" => :mavericks
    sha256 "ce96ad3bda840699a6576849a44ededc184e0a9db76dbaabe4a4e0209f344768" => :mountain_lion
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
