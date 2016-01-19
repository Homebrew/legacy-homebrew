class Wslay < Formula
  desc "C websocket library"
  homepage "http://wslay.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wslay/wslay-1.0.0/wslay-1.0.0.tar.xz"
  sha256 "148d5272255b76034f97cf0298f606aed4908ebb4198412a321280f2319160ef"

  bottle do
    cellar :any
    revision 1
    sha256 "30939fd620cff4702d15d61a75774b71e1b226fb7b2b3fab8a3acdf96bdd9b7d" => :el_capitan
    sha256 "294d4646dcf7d352368de8b422a5354e72b3027a8678e993d68ea8d55646388e" => :yosemite
    sha256 "410634e15d5ce6f680ccd5d96b97fc2226aad9530aebe42690d3ceb4d7011e69" => :mavericks
  end

  option "without-docs", "Don't generate or install documentation"

  head do
    url "https://github.com/tatsuhiro-t/wslay.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "cunit" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end
end
