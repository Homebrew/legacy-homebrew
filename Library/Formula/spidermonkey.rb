require 'formula'

class Spidermonkey < Formula
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  url 'http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz'
  version '1.8.5'
  sha1 '52a01449c48d7a117b35f213d3e4263578d846d6'

  head 'https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz'

  conflicts_with 'narwhal', :because => 'both install a js binary'

  depends_on 'readline'
  depends_on 'nspr'

  def install
    # aparently this flag causes the build to fail for ivanvc on 10.5 with a
    # penryn (core 2 duo) CPU. So lets be cautious here and remove it.
    ENV['CFLAGS'] = ENV['CFLAGS'].gsub(/-msse[^\s]+/, '') if MacOS.version <= :leopard

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
