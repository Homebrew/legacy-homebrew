class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 2

  bottle do
    revision 1
    sha1 "97954464d63684d343152aa3dbb7bd5384d8e56d" => :mavericks
    sha1 "882e21d742e1f373b9403ef932bddc855430948e" => :mountain_lion
    sha1 "ce8f6c3521d89ed3c0e3f09813934154ec6b4bcb" => :lion
  end

  devel do
    url "http://elinks.cz/download/elinks-0.12pre6.tar.bz2"
    version "0.12pre6"
    sha256 "383646375b8a325bef5a132c8300caab90eb0b842c5f8eff68febc00e29acada"
  end

  head do
    url "http://elinks.cz/elinks.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    ENV.delete("LD")
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey",
                          "--enable-256-colors"
    system "make", "install"
  end

  test do
    (testpath/"test.html").write <<-EOS.undent
      <!DOCTYPE html>
      <title>elinks test</title>
      Hello world!
      <ol><li>one</li><li>two</li></ol>
    EOS
    assert_match /^\s*Hello world!\n+ *1. one\n *2. two\s*$/,
                 shell_output("elinks test.html")
  end
end
