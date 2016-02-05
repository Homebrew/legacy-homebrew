class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 2

  bottle do
    revision 1
    sha256 "4a4ba514c46b18fa2925bb28cb83eebe085ad6795ed84bdd411a2bedae2ee4d0" => :mavericks
    sha256 "06842f124db95b48c26f071419bd12f88a25c5b08ae519d22453971d5d4feea4" => :mountain_lion
    sha256 "f54731731b2422afc2ecb1021f7e9d5b152479480fb93856aae8510091210ebb" => :lion
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
