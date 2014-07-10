require 'formula'

class Libflowmanager < Formula
  homepage 'http://research.wand.net.nz/software/libflowmanager.php'
  url 'http://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.4.tar.gz'
  sha1 'fba31188c912433d3496bb0249da2a5d029a7b2e'

  bottle do
    cellar :any
    sha1 "0d16250d56ea2294d8efa59267402d4d7b063875" => :mavericks
    sha1 "633bdb981f0996db2d751ee540b5831d9ca2cab6" => :mountain_lion
    sha1 "c3a5ace38da4ffbf34f164b308a3b5afaf714072" => :lion
  end

  depends_on 'libtrace'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
