require 'brewkit'

class Spidermonkey <Formula  
  @url="http://ftp.mozilla.org/pub/mozilla.org/js/js-1.7.0.tar.gz"
  @homepage='https://developer.mozilla.org/en/SpiderMonkey'
  @md5='5571134c3863686b623ebe4e6b1f6fe6'

  def deps
    # You can build Python without readline, but you really don't want to.
    LibraryDep.new 'readline'
    LibraryDep.new 'nspr'
  end

  def patches
    ["http://gist.github.com/raw/179415/eed70f1b4bae73fb92995eaf07870d40c0ceb03e/gistfile1.diff"]
  end

  def install
    ENV.j1
    Dir.chdir "src" do
      system "make JS_DIST=#{HOMEBREW_PREFIX} JS_THREADSAFE=1 -f Makefile.ref"
      system "make JS_DIST=#{prefix} -f Makefile.ref export"
      system "ranlib #{prefix}/lib/libjs.a"
    end
  end
end

