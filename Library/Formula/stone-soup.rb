require 'formula'

class StoneSoup < Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.9.0/stone_soup-0.9.0.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 '8c5a5d44b18733076cc95925315107bc'

  # Keep empty folders for save games and such
  skip_clean :all

  def options
    [['--with-tiles', 'compile the tiles version']]
  end

  def install
    ENV.x11
    Dir.chdir "source"

    if ARGV.include? '--with-tiles'
      # works out of the box
      system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "TILES=y", "install"
    else
      # if XCode 4 is installed on Snow Leopard, then forcing the framework breaks the build, so remove it.
      # Xcode3 should be fine out of the box.
      if File.directory? "/Developer-old"
        inreplace "makefile" do |s|
          s.gsub!(
                  "CC = $(GCC) $(CFLAGS_ARCH) -isysroot $(SDKROOT) -mmacosx-version-min=$(SDK_VER)",
                  "CC = $(GCC) $(CFLAGS_ARCH)"
                  )
          s.gsub!(
                  "CXX = $(GXX) $(CFLAGS_ARCH) -isysroot $(SDKROOT) -mmacosx-version-min=$(SDK_VER)",
                  "CXX = $(GXX) $(CFLAGS_ARCH)"
                  )
          s.gsub!(
                  "DEPCC = $(GCC) $(or $(CFLAGS_DEPCC_ARCH),$(CFLAGS_ARCH)) -isysroot $(SDKROOT) -mmacosx-version-min=$(SDK_VER)",
                  "DEPCC = $(GCC) $(or $(CFLAGS_DEPCC_ARCH),$(CFLAGS_ARCH))"
                  )
          s.gsub!(
                  "DEPCXX = $(GXX) $(or $(CFLAGS_DEPCC_ARCH),$(CFLAGS_ARCH)) -isysroot $(SDKROOT) -mmacosx-version-min=$(SDK_VER)",
                  "DEPCXX = $(GXX) $(or $(CFLAGS_DEPCC_ARCH),$(CFLAGS_ARCH))"
                  )
        end
        system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "install"
      end
    end
  end
end
