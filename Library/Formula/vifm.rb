require "formula"

class Vifm < Formula
  homepage "http://vifm.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.7.8.tar.bz2"
  sha256 '5dfbb26c2038a58dcff12026dab736e29d547b4aa3ff5912e4d844064c9e7603'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    ENV.deparallelize
    system "make install"
  end
end
