require 'formula'

class Scantailor < Formula
  class Version < ::Version
    def enhanced?
      tokens[0].to_s == "enhanced"
    end

    def <=>(other)
      other = self.class.new(other)
      if enhanced? && other.enhanced?
        super
      elsif enhanced?
        1
      elsif other.enhanced?
        -1
      else
        super
      end
    end
  end

  homepage 'http://scantailor.org/'
  url 'https://downloads.sourceforge.net/project/scantailor/scantailor/0.9.11.1/scantailor-0.9.11.1.tar.gz'
  version Scantailor::Version.new("0.9.11.1")
  sha1 '80970bbcd65fbf8bc62c0ff0cb7bcb78c86961c3'

  devel do
    url 'https://downloads.sourceforge.net/project/scantailor/scantailor-devel/enhanced/scantailor-enhanced-20140214.tar.bz2'
    version Scantailor::Version.new("enhanced-20140214")
    sha1 'e90b861f02a571184b8ab9d5ef59dd57dcf1c212'
  end

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on :x11

  # bad interaction with boost 1.57
  # https://github.com/scantailor/scantailor/issues/125
  fails_with :clang

  def install
    system "cmake", ".", "-DPNG_INCLUDE_DIR=#{MacOS::X11.include}", *std_cmake_args
    system "make install"
  end
end
