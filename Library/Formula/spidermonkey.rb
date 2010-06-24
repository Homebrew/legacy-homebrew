require 'formula'

class Spidermonkey <Formula
  # Use a 3rd party tarball, since Mozilla hasn't made a stable one since version 1.7
  # Use 1.9.3 for proper x64 support on OS X.
  url 'http://packaging-spidermonkey.googlecode.com/files/libmozjs-1.9.3-1.5.tar.bz2'
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  sha1 '6ab671497497da12f0a17790b19a1d2d487d3c63'
  version '1.9.3'

  depends_on 'readline'
  depends_on 'nspr'

  def install
    if MACOS_VERSION == 10.5
      # aparently this flag causes the build to fail for ivanvc on 10.5 with a
      # penryn (core 2 duo) CPU. So lets be cautious here and remove it.
      # It might not be need with newer spidermonkeys anymore tho.
      ENV['CFLAGS'] = ENV['CFLAGS'].gsub(/-msse[^\s]+/, '')
    end

    # Remove the broken *(for anyone but FF) install_name
    inreplace "config/rules.mk", "-install_name @executable_path/$(SHARED_LIBRARY) ", ""

    mkdir "brew-build"
    Dir.chdir "brew-build" do
      system "../configure", "--prefix=#{prefix}",
                             "--enable-readline",
                             "--enable-threadsafe",
                             "--with-system-nspr",
                             "--enable-macos-target=#{MACOS_VERSION}"
      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"

      # Can't do `make install` right off the bat sadly
      system "make"
      system "make install"

      # The `js` binary ins't installed. Lets do that too, eh?
      bin.install "shell/js"
    end
  end
end
