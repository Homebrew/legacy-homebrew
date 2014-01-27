require "formula"

class Taktuk < Formula
  homepage "http://http://taktuk.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/30903/taktuk-3.7.4.tar.gz"
  sha1 "947de1e9810316142815df3077e3f629680de564"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
