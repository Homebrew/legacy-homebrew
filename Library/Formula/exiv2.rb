require 'formula'

class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage 'http://www.exiv2.org'
  url 'http://www.exiv2.org/exiv2-0.24.tar.gz'
  sha1 '2f19538e54f8c21c180fa96d17677b7cff7dc1bb'

  bottle do
    cellar :any
    sha1 '2b40116bf2f81fc36df6c783923a52cc3b6bfabb' => :mavericks
    sha1 'b54795033eba76504c2d4f92b784976a5cb8b555' => :mountain_lion
    sha1 '57cfbff226fcb74cc152d0e70522092c0a894b05' => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
