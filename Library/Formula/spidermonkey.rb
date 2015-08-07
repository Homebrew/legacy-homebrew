class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  revision 1

  head "https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz"

  bottle do
    sha256 "7ab660cad3aac11fbf4befa3fbbf65a7ee64d858539ad81298271389b2957375" => :yosemite
    sha256 "cda0b81bd974640690fe067691efca6bc7d1583117cd5db28cca43ab8e2f884c" => :mavericks
    sha256 "769035a4fa0ed09b71aa9747c2834a51285903e51d9bc478f865c037a8666370" => :mountain_lion
  end

  conflicts_with "narwhal", :because => "both install a js binary"

  depends_on "readline"
  depends_on "nspr"

  def install
    cd "js/src" do
      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/rules.mk",
        "-install_name @executable_path/$(SHARED_LIBRARY) ",
        "-install_name #{lib}/$(SHARED_LIBRARY) "
    end

    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      # These need to be in separate steps.
      system "make"
      system "make", "install"

      # Also install js REPL.
      bin.install "shell/js"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
