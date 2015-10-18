class Openslp < Formula
  desc "Implementation of Service Location Protocol"
  homepage "http://www.openslp.org"
  url "https://downloads.sourceforge.net/project/openslp/2.0.0/2.0.0%20Release/openslp-2.0.0.tar.gz"
  sha256 "924337a2a8e5be043ebaea2a78365c7427ac6e9cee24610a0780808b2ba7579b"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
