class Wslay < Formula
  desc "C websocket library"
  homepage "http://wslay.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wslay/wslay-1.0.0/wslay-1.0.0.tar.xz"
  sha1 "199308322e67094ee803063eca0077dfc042bc77"

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
    sha1 "3a11f130c63b057532ca37fe49c8967d0cbae1d5"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha1 "002450621b33c5690060345b0aac25bc2426d675"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
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
