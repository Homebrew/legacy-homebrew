require 'formula'

SPIDERMONKEY_PREFIX = 'spidermonkey'

# Internal version of SpiderMonkey (1.7.0) with patches for compile & install on OS X,
# can be replaced by Homebrew version when it is possible to specify version dependencies
# in Homebrew formula.
class Spidermonkey < Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/js/js-1.7.0.tar.gz'
  homepage 'https://developer.mozilla.org/en/SpiderMonkey'
  md5 '5571134c3863686b623ebe4e6b1f6fe6'
  
  depends_on 'readline'
  depends_on 'nspr'
  
  # Install as keg_only as we only need it for MediaTomb (AFAIK).
  keg_only "This is an older version of SpiderMonkey that is still required for MediaTomb."
  
  def patches
    { :p0 => "https://raw.github.com/gist/1530302/17d40f01933859cd985bf180de2fa1f1d24f8e9d/spidermonkey-1.7.0-osx.diff" }
  end
  
  def install
    ENV.deparallelize
    ENV.no_optimization
    
    make_opts = "-f Makefile.ref"
    
    # Install directly into the MediaTomb prefix, this way it's self contained as will
    # be cleaned up when MediaTomb is uninstalled.
    prefix = ::Mediatomb.new.prefix.join(SPIDERMONKEY_PREFIX)
    
    Dir.chdir "src" do
      inreplace 'Makefile.ref' do |s|
        s.gsub!("__PREFIX__", prefix)
        s.gsub!("__USER__", `id -un`)
        s.gsub!("__GROUP__", `id -gn`)
      end
      
      # Has no 'configure' script so run a parameterized 'make' command instead.
      system "make BUILD_OPT=1 LIBDIR=\"#{prefix}/lib\" SO_SUFFIX=dylib JS_THREADSAFE=1 \
                    JS_READLINE=1 JS_DIST=#{HOMEBREW_PREFIX} DIST=#{HOMEBREW_PREFIX} #{make_opts}"      
      system "make install #{make_opts}"
    end
  end
end

class Mediatomb < Formula
  url 'http://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz'
  homepage 'http://mediatomb.cc'
  md5 'e927dd5dc52d3cfcebd8ca1af6f0d3c2'
  
  def options
    [
      ['--video-thumbnail', "Enable support for video thumbnails (useful for PS3 etc.)"],
      ['--lastfm', "Enable Last.fm support"]
    ]
  end
  
  # All these are necessary to make MediaTomb useful, enables transcoding
  # and metadata parsing to be used.
  depends_on 'ffmpeg'
  depends_on 'mp4v2'
  depends_on 'taglib'
  depends_on 'libexif'
  depends_on 'libmagic'
  
  if ARGV.include? '--video-thumbnail'
    depends_on 'ffmpegthumbnailer'
  end
  
  if ARGV.include? '--lastfm'
    depends_on 'lastfmlib'
  end
  
  # Hack (probably a better way) so SpiderMonkey gets the correct prefix.
  def initialize name='__UNKNOWN__', path=nil
    super 'mediatomb', path
  end

  # This is for libav 0.7 support.
  # See https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431 for details.
  def patches
    "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"
  end
  
  def install
    # SpiderMonkey is required by MediaTomb for playlist & custom import script support.
    ::Spidermonkey.new.brew do |f|
      f.install
    end
    spidermonkey_prefix = prefix.join(SPIDERMONKEY_PREFIX)
    
    # Disable MySQL as SQLite comes as default (this is an explicit disable, previously
    # it would compiled with MySQL as 'unavailable' as it was not a dependancy). We are
    # also disabling inotify as it is Linux specific.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mysql=disabled",
                          "--enable-inotify=disabled",
                          "--with-js-h=#{spidermonkey_prefix}/include/js",
                          "--with-js-libs=#{spidermonkey_prefix}/lib"
    system "make install"
  end
end
