require 'formula'

class Spidermonkey <Formula  
  # There are no proper releases of spidermonkey. So pick a specific/constant
  # revision:  r35345
  url 'http://hg.mozilla.org/tracemonkey/archive/57a6ad20eae9.tar.gz'
  md5 '4a143399f69d6509bd980073096af6d4'

  version '1.9.2'

  homepage 'https://developer.mozilla.org/en/SpiderMonkey'

  head 'hg://http://hg.mozilla.org/tracemonkey'

  depends_on 'readline'
  depends_on 'nspr'
  depends_on 'autoconf213'

  def install

    if MACOS_VERSION == 10.5
      # aparently this flag causes the build to fail for ivanvc on 10.5 with a
      # penryn (core 2 duo) CPU. So lets be cautious here and remove it.
      # It might not be need with newer spidermonkeys anymore tho.
      ENV['CFLAGS'] = ENV['CFLAGS'].gsub(/-msse[^\s]+/, '')
    end

    Dir.chdir "js/src" do
      # Fixes a bug with linking against CoreFoundation. Tests all pass after
      # building like this. See: http://openradar.appspot.com/7209349
      inreplace "configure.in", "LDFLAGS=\"$LDFLAGS -framework Cocoa\"", ""
      system "autoconf213"
      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/rules.mk", "-install_name @executable_path/$(SHARED_LIBRARY) ", ""
    end

    FileUtils.mkdir "brew-build";

    Dir.chdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr"

      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"

      # Can't do `make install` right off the bat sadly
      system "make"
      system "make install"

      # The `js` binary ins't installed. Lets do that too, eh?
      bin.install "shell/js"
    end

  end
end
