require "formula"

class Shogun < Formula
  homepage "http://shogun-toolbox.org"
  url "http://shogun-toolbox.org/archives/shogun/releases/3.2/sources/shogun-3.2.0.tar.bz2"
  sha1 "442e212a19d0297b4df45a4dfe7deb6312441e54"

  depends_on 'cmake' => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
