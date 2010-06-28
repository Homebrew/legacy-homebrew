require 'formula'

class Spidermonkey <Formula
  # There are no proper releases of spidermonkey, so pick a version that's known
  # to work (especially with CouchDB).
  # revision: r35345
  url 'http://hg.mozilla.org/tracemonkey/archive/57a6ad20eae9.tar.gz'
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  md5 '2d8cf22da82b30c36f47675a8486a3f3'
  version '1.8.5'

  depends_on 'readline'
  depends_on 'nspr'

  def install
    if MACOS_VERSION == 10.5
      # aparently this flag causes the build to fail for ivanvc on 10.5 with a
      # penryn (core 2 duo) CPU. So lets be cautious here and remove it.
      # It might not be need with newer spidermonkeys anymore tho.
      ENV['CFLAGS'] = ENV['CFLAGS'].gsub(/-msse[^\s]+/, '')
    end

    # For some reason SpiderMonkey requires Autoconf-2.13
    ac213_prefix = Pathname.pwd.join('ac213')
    Autoconf213.new.brew do |f|
      # probably no longer required, see issue #751
      inreplace 'configure', 'for ac_prog in mawk gawk nawk awk', 'for ac_prog in awk'

      system "./configure", "--disable-debug",
                            "--program-suffix=213",
                            "--prefix=#{ac213_prefix}"
      system "make install"
    end

    Dir.chdir "js/src" do
      # Fixes a bug with linking against CoreFoundation. Tests all pass after
      # building like this. See: http://openradar.appspot.com/7209349
      inreplace "configure.in", "LDFLAGS=\"$LDFLAGS -framework Cocoa\"", ""
      system "#{ac213_prefix}/bin/autoconf213"
      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/rules.mk", "-install_name @executable_path/$(SHARED_LIBRARY) ", ""
    end

    FileUtils.mkdir "brew-build"

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


class Autoconf213 <Formula
  url 'http://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.13.tar.gz'
  md5 '9de56d4a161a723228220b0f425dc711'
  homepage 'http://www.gnu.org/software/autoconf/'
end
