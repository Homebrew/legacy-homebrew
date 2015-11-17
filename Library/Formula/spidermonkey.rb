class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  revision 1

  head "https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz"

  bottle do
    cellar :any
    revision 1
    sha256 "7a5c888484415d2de3d0b1e980a0895578f1d5df816863dc553ef499b488c203" => :el_capitan
    sha256 "3770ceced1be2ef3de507894ed98548c72ecd469e49176f6cf1f8e7c890a8d84" => :yosemite
    sha256 "a48533ba8f2e0edbb635d5b7270740c8f86c3800e71489ed02cbf9869c874748" => :mavericks
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
