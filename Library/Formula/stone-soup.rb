require 'formula'

class StoneSoup < Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.7.2/stone_soup-0.7.2.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 'ffb54c88d280f036a3819cba23bc4489'

  # Keep empty folders for save games and such
  skip_clean :all

  def install
    Dir.chdir "source"

    # Hacks here by Adam V (@flangy) aided by @mistydemeo
    # Arch / SDK detection is somewhat bogus: 32 vs 64-bit is detected wrong
    # and the 10.4 SDK is selected too aggressively.
    # Fix up what it detects
    target_arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"

    inreplace "makefile" do |s|
      s.gsub!(
        "CC = $(GCC) -arch $(ARCH) -isysroot $(SDKROOT) -mmacosx-version-min=$(SDK_VER)",
        "CC = #{ENV.cc} -arch #{target_arch} -isysroot #{MacOS.xcode_prefix}/SDKs/MacOSX#{MACOS_VERSION}.sdk -mmacosx-version-min=#{MACOS_VERSION}"
        )
      s.gsub!(
        "CXX = $(GXX) -arch $(ARCH) -isysroot $(SDKROOT) -mmacosx-version-min=$(SDK_VER)",
        "CXX = #{ENV.cxx} -arch #{target_arch} -isysroot #{MacOS.xcode_prefix}/SDKs/MacOSX#{MACOS_VERSION}.sdk -mmacosx-version-min=#{MACOS_VERSION}"
        )
    end
    system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "install"
  end
end
