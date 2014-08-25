require "formula"

class Liblacewing < Formula
  homepage "http://lacewing-project.org/"
  head "https://github.com/udp/lacewing.git"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha1 "078486a4dcd6ce33c2c881954c5dc82843411ac9"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "1ee2695dd358967460b3727931a79d033fb9abe9" => :mavericks
    sha1 "f6a2b36e4675c726d727f344665060fd084d8d94" => :mountain_lion
    sha1 "5cac12ddf876a1aee0ca068121d02ca806275dec" => :lion
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
