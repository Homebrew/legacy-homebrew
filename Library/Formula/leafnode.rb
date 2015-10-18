class Leafnode < Formula
  desc "Leafnode is a store and forward NNTP proxy"
  homepage "http://sourceforge.net/projects/leafnode/"
  url "https://downloads.sourceforge.net/project/leafnode/leafnode/1.11.10/leafnode-1.11.10.tar.bz2"
  sha256 "d75ba79961a8900b273eb74c3ad6976bf9fd64c2fa0284273e65f98190c5f2bc"

  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
