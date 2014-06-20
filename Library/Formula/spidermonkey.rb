require 'formula'

class Spidermonkey < Formula
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  url 'http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz'
  version '1.8.5'
  sha1 '52a01449c48d7a117b35f213d3e4263578d846d6'

  head 'https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz'

  bottle do
    sha1 "c23bfeffb2cdfba00957c13444d123a6de5ac42c" => :mavericks
    sha1 "cfb242ee6fa552a68036f5a736abb805359453e4" => :mountain_lion
    sha1 "2a4e8a21f64c3516782e8ab649962e4b215d37a8" => :lion
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

    output = `#{bin}/js #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
