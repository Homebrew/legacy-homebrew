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

  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")
  depends_on "cunit" => :build
  depends_on "pkg-config" => :build

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha256 "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  def install
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end
      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
    end

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end
end
