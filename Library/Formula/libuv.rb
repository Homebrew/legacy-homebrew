class Libuv < Formula
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.4.2.tar.gz"
  sha1 "85882c7e0b6ce77c30240a895c62d158e04b361e"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha1 "b2698a14753dfe1adc790472ad88a271b9aaf435" => :yosemite
    sha1 "2aeb30d3fadf2ab172feeb4151a096104fb6267c" => :mavericks
    sha1 "6027a89608cdf0c5e99b088ef360b654e8f1ce20" => :mountain_lion
  end

  option "without-docs", "Don't build and install documentation"
  option :universal

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")

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
    ENV.universal_binary if build.universal?

    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end
      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
      # This isn't yet handled by the make install process sadly.
      cd "docs" do
        system "make", "man"
        system "make", "singlehtml"
        man1.install "build/man/libuv.1"
        doc.install Dir["build/singlehtml/*"]
      end
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <uv.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-luv", "-o", "test"
    system "./test"
  end
end
