require 'formula'

class Spidermonkey < Formula
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  url 'http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz'
  version '1.8.5'
  sha1 '52a01449c48d7a117b35f213d3e4263578d846d6'

  head 'https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz'

  bottle do
    revision 1
    sha1 "6c6fd6d40d41764a086a6fb134176253deb1a51b" => :yosemite
    sha1 "5d19010b10a5f1827511ca791debf9f2d9076e47" => :mavericks
    sha1 "37d04b64aba47dbf65f197aec94da9acf5f1fd4c" => :mountain_lion
  end

  conflicts_with 'narwhal', :because => 'both install a js binary'

  depends_on 'readline'
  depends_on 'nspr'

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
                                    "--enable-macos-target=#{MacOS.version}"

      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      # These need to be in separate steps.
      system "make"
      system "make install"

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
