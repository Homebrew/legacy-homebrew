class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.1.1.tar.gz"
  sha256 "50c5179fd564b829b6b2cec087e66f10cf8799601de19350df0772ae77e4852f"

  bottle do
    cellar :any
    sha256 "fcb12bec3a384607e4f61a05fca637eb6c48d9821a26715abe83100210f480f9" => :yosemite
    sha256 "0995b3eb60f7f312653189d4aec8d40f1376c2970ab58d5cc5f9b2a17fefaa2b" => :mavericks
    sha256 "f54b52c2c174a6e29afc9c519dc3c3c92d9c05b6805dd29650e0711a20bab007" => :mountain_lion
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
    system "make", "install"
    system "make install-doc-man" if build.with? "docs"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion_code = """\
#compdef tig

_tig () {
  local e
  e=$(dirname ${funcsourcetrace[1]%:*})/tig-completion.bash
  if [ -f $e ]; then
    . $e
  fi
}"""
    File.open("contrib/_tig", "w") {|f| f.write(zsh_completion_code)}
    zsh_completion.install "contrib/_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end
end
