require "formula"

class Taktuk < Formula
  homepage "http://taktuk.gforge.inria.fr/"
  url "http://gforge.inria.fr/frs/download.php/30903/taktuk-3.7.4.tar.gz"
  sha1 "947de1e9810316142815df3077e3f629680de564"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make",
    ENV.j1
    system "make", "install"
  end
end
