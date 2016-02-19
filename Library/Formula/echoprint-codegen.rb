class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "http://echoprint.me"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "c40eb79af3abdb1e785b6a48a874ccfb0e9721d7d180626fe29c72a29acd3845"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    revision 1
    sha256 "b3fce2ef476e9b62a1f90a795ba142d0587eea87a2bef5bd010609f933cb93ba" => :yosemite
    sha256 "02e03a969cc7efba2a8d43a7783d9d3354df14f3148730f47170681167dec99c" => :mavericks
    sha256 "9538866db7e68b664c9aebc22241bf00acec9b19629b08c1cedf6f87f5ec5dc6" => :mountain_lion
  end

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
