class Liblacewing < Formula
  desc "Cross-platform, high-level C/C++ networking library"
  homepage "http://lacewing-project.org/"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha256 "c24370f82a05ddadffbc6e79aaef4a307de926e9e4def18fb2775d48e4804f5c"
  revision 1
  head "https://github.com/udp/lacewing.git"

  bottle do
    cellar :any
    revision 3
    sha256 "8521b6bdb48855fb5e87d3354d65db5d476c56b416807145c9e9f05500ae91d5" => :el_capitan
    sha256 "8df9b4bab55b90fe7892187dd711aa40898ff83c6b66a02a18bdbef87ad2fa6c" => :yosemite
    sha256 "af978e720eafc9106c8dcb9391b341ec984339fd87db419f54229c5ae3a03d8c" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # https://github.com/udp/lacewing/issues/104
    mv "#{lib}/liblacewing.dylib.0.5", "#{lib}/liblacewing.0.5.dylib"
  end
end
