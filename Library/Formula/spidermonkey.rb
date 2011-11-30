require 'formula'

# Private older version of autoconf required to compile Spidermonkey
class Autoconf213 < Formula
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.13.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz'
  md5 '9de56d4a161a723228220b0f425dc711'
  homepage 'http://www.gnu.org/software/autoconf/'
end

class Spidermonkey < Formula
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  # Pick a version that's known to work with CouchDB), revision r35345.
  url 'http://hg.mozilla.org/tracemonkey/archive/57a6ad20eae9.tar.gz'
  md5 '0f2490f78d880ec184d9233df97ab83d'
  version '1.8.0'

  depends_on 'readline'
  depends_on 'nspr'

  def install
    # aparently this flag causes the build to fail for ivanvc on 10.5 with a
    # penryn (core 2 duo) CPU. So lets be cautious here and remove it.
    ENV['CFLAGS'] = ENV['CFLAGS'].gsub(/-msse[^\s]+/, '') if MacOS.leopard?

    # For some reason SpiderMonkey requires Autoconf-2.13
    ac213_prefix = Pathname.pwd.join('ac213')
    Autoconf213.new.brew do |f|
      # Force use of plain "awk"
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
      inreplace "config/rules.mk",
        "-install_name @executable_path/$(SHARED_LIBRARY) ",
        "-install_name #{lib}/$(SHARED_LIBRARY) "
    end

    mkdir "brew-build"

    Dir.chdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr"

      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      # These need to be in separate steps.
      system "make"
      system "make install"

      # Also install js REPL.
      bin.install "shell/js"
    end
  end

  def caveats; <<-EOS.undent
    This formula installs Spidermonkey 1.8.x.

    If you are trying to compile MongoDB from scratch, you will need 1.7.x instead.
    EOS
  end
end
