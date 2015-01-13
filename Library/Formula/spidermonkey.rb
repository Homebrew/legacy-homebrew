require "formula"

class Spidermonkey < Formula
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
  url "https://ftp.mozilla.org/pub/mozilla.org/js/mozjs-24.2.0.tar.bz2"
  sha1 "ce779081cc11bd0c871c6f303fc4a0091cf4fe66"

  depends_on "yasm" => :build
  depends_on "gawk" => :build
  depends_on "libidl" => :build
  depends_on "ccache" => :build

  head do
    depends_on "homebrew/versions/autoconf213"
    url "https://hg.mozilla.org/mozilla-central/archive/tip.tar.bz2"
  end

  conflicts_with "narwhal", :because => "both install a js binary"

  depends_on "readline"
  depends_on "nspr"

  def install
    if build.head?
      jsconfig = "js/src/js-config"
      jsbin = "js/src/shell/js"
      cd "js/src" do
        system "autoconf213"
      end
    else
      jsconfig = "js24-config"
      jsbin = "shell/js24"
      cd "js/src" do
        # Remove the broken *(for anyone but FF) install_name
        inreplace "config/rules.mk",
          "-install_name @executable_path/$(SHARED_LIBRARY) ",
          "-install_name #{lib}/$(SHARED_LIBRARY) "
      end
    end

    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--enable-macos-target=#{MacOS.version}"

      inreplace jsconfig, /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      # These need to be in separate steps.
      system "make"
      system "make install"

      # Also install js REPL.
      bin.install jsbin => "js"
      bin.install jsconfig => "js-config"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
