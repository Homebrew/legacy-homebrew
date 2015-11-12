class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "http://echoprint.me"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "c40eb79af3abdb1e785b6a48a874ccfb0e9721d7d180626fe29c72a29acd3845"
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    revision 1
    sha1 "64d6275b2830c9eb0543e2a0cb9c9807a3fc8995" => :yosemite
    sha1 "f0f20a5b66a1dd4f16b5676c0593ebb8872f20fb" => :mavericks
    sha1 "0a7c0d80cfe1213e2831d5bf26351de4886da60a" => :mountain_lion
  end

  revision 1

  depends_on "ffmpeg"
  depends_on "taglib"
  depends_on "boost"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.diff"
    sha256 "0ab8e1ffafeeb44195246a78923d0d943d583279442b404c0af65ac1c5cbe74c"
  end

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
