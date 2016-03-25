class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "http://echoprint.me"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "c40eb79af3abdb1e785b6a48a874ccfb0e9721d7d180626fe29c72a29acd3845"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    sha256 "047111c6a160f827a000aa4184f78d579b7fb8ecbb13db6b11d3a6f79c243783" => :el_capitan
    sha256 "2de00aaf98a53d77f0d3d4b0af5e8457a2fdb708769524c60c8fea94d0b5f7cc" => :yosemite
    sha256 "7dfecc154ab9c57918073f46095484616e049ed365b95015432e2416bc425bea" => :mavericks
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
