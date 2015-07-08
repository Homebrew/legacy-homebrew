require 'formula'

class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  url "https://people.mozilla.org/~sstangl/mozjs-31.5.0.tar.bz2"
  sha256 "4d63976b88c4e2135f1bd6d1f85285fe299713cde4baf2fe1b2f4058286611e1"

  head 'https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz'

  bottle do
  end

  conflicts_with 'narwhal', :because => 'both install a js binary'

  depends_on :python if MacOS.version <= :yosemite
  depends_on 'readline'
  depends_on 'nspr'

  def install
    # Remove the broken *(for anyone but FF) install_name
    inreplace "config/rules.mk",
              "-install_name @executable_path/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      cd "js/src" do
        inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      end

      # These need to be in separate steps.
      system "make"
      system "make install"

      # Also install js REPL.
      bin.install "js/src/shell/js"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
