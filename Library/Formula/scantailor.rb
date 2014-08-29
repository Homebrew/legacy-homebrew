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

  # Makes Scan Tailor work with Clang on OS X Mavericks
  # Approved by maintainer and included in official repository.
  # See: http://sourceforge.net/p/scantailor/mailman/message/31884956/
  patch :p1 do
    url "https://gist.githubusercontent.com/muellermartin/8569243/raw/b09215037b346787e0f501ae60966002fd79602e/scantailor-0.9.11.1-clang.patch"
    sha1 "4594b28bcf9409ef252638830c633dd42c63bc40"
  end

  def install
    system "cmake", ".", "-DPNG_INCLUDE_DIR=#{MacOS::X11.include}", *std_cmake_args
    system "make install"
  end
end
