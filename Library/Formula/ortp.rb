require "formula"

class Ortp < Formula
  homepage "http://www.linphone.org/eng/documentation/dev/ortp.html"
  url "http://download.savannah.gnu.org/releases/linphone/ortp/sources/ortp-0.23.0.tar.gz"
  sha1 "87a154295636652cc9ac7310dc02e0258db08790"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
