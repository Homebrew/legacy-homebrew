require "formula"

class Tig < Formula
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.1.tar.gz"
  sha1 "2527cfee62a890f25c7c2ae8c1a16e5fa201ce29"

  bottle do
    cellar :any
    revision 1
    sha256 "09d7a29550166599f142033aa558157f9da760753fafc2217aa0f32c5efe43d2" => :yosemite
    sha256 "d52d53d7c3340ef28da693a21c8d11940b5d05a88741d9e548712bd2be95b1b6" => :mavericks
    sha256 "2997c4eb4d022a39640cf3b971fe2d34f302da05f245f359884909168a0afbb2" => :mountain_lion
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build man pages using asciidoc and xmlto"

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  depends_on "readline" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man" if build.with? "docs"
    bash_completion.install "contrib/tig-completion.bash"
  end
end
