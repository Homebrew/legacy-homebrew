require 'formula'

class Pixman < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.24.4.tar.gz'
  sha1 'efaa09789128ebc42d17a11d2e350b7217a7cd05'

  depends_on 'pkg-config' => :build

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.x11
    ENV.universal_binary if ARGV.build_universal?
    if ENV.compiler == :llvm
      if MacOS.xcode_version >= "4.1"
        ENV.clang
      else
        ENV.gcc_4_2
      end
    end

    # Disable gtk as it is only used to build tests
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gtk=no"
    system "make install"
  end
end
