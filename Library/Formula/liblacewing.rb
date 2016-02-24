class Liblacewing < Formula
  desc "Cross-platform, high-level C/C++ networking library"
  homepage "http://lacewing-project.org/"
  head "https://github.com/udp/lacewing.git"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha256 "c24370f82a05ddadffbc6e79aaef4a307de926e9e4def18fb2775d48e4804f5c"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "46eef4fac2c25cae19b7500fee44b50851d753aeacc0d5f23dd9d54525a6adde" => :yosemite
    sha256 "5ab6eb5fc3abee7e8b2027838c34ec689165694d60c4126e2ed71653e92b40ca" => :mavericks
    sha256 "0302988d6edbdd9d3235dc990bb7625a207526c2fed3dc55091356be7a4332e8" => :mountain_lion
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
