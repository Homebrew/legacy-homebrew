class Wslay < Formula
  desc "C websocket library"
  homepage "http://wslay.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wslay/wslay-1.0.0/wslay-1.0.0.tar.xz"
  sha256 "148d5272255b76034f97cf0298f606aed4908ebb4198412a321280f2319160ef"

  bottle do
    cellar :any
    sha1 "d5996cbcaefa8fb31052257c83eccb1121721a35" => :yosemite
    sha1 "0352cd0da3febe6bfc917f620acd3b694899bcd4" => :mavericks
    sha1 "04cfebe7140b51febd90b99e2a398bca966759dc" => :mountain_lion
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
