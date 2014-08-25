require "formula"

class Liblacewing < Formula
  homepage "http://lacewing-project.org/"
  head "https://github.com/udp/lacewing.git"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha1 "078486a4dcd6ce33c2c881954c5dc82843411ac9"
  revision 1

  bottle do
    cellar :any
    sha1 "581217cd2f70273475b3ea50ab2faafbcf6898f0" => :mavericks
    sha1 "620f9e799192d74e49a5a2098d0661b69b3f3a14" => :mountain_lion
    sha1 "39c2c5dfd392344bba96f177b8afc79ab6fc73b8" => :lion
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
