require 'formula'

class Tinyxml < Formula
  homepage 'http://www.grinninglizard.com/tinyxml/'
  url 'http://downloads.sourceforge.net/project/tinyxml/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz'
  sha1 'cba3f50dd657cb1434674a03b21394df9913d764'

  option :universal

  depends_on 'cmake' => :build

  def patches
    # The first two patches are taken from the debian packaging of tinyxml.
    #   The first patch enforces use of stl strings, rather than a custom string type.
    #   The second patch is a fix for incorrect encoding of elements with special characters
    #   originally posted at http://sourceforge.net/p/tinyxml/patches/51/
    # The third patch adds a CMakeLists.txt file to build a shared library and provide an install target
    #   submitted upstream as https://sourceforge.net/p/tinyxml/patches/66/
    [
      'http://patch-tracker.debian.org/patch/series/dl/tinyxml/2.6.2-2/enforce-use-stl.patch',
      'http://patch-tracker.debian.org/patch/series/dl/tinyxml/2.6.2-2/entity-encoding.patch',
      'https://gist.github.com/scpeters/6325123/raw/cfb079be67997cb19a1aee60449714a1dedefed5/tinyxml_CMakeLists.patch',
    ]
  end

  def install
    ENV.universal_binary if build.universal?
    system "cmake", *std_cmake_args
    system "make", "install"
  end
end
