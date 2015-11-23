class Leafnode < Formula
  desc "Leafnode is a store and forward NNTP proxy"
  homepage "https://sourceforge.net/projects/leafnode/"
  url "https://downloads.sourceforge.net/project/leafnode/leafnode/1.11.10/leafnode-1.11.10.tar.bz2"
  sha256 "d75ba79961a8900b273eb74c3ad6976bf9fd64c2fa0284273e65f98190c5f2bc"

  bottle :disable, "leafnode hardcodes the user at compile time with no override available."

  depends_on "pcre"

  def install
    (var/"spool/news/leafnode").mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--with-user=#{ENV["USER"]}", "--with-group=admin",
                          "--sysconfdir=#{etc}/leafnode", "--with-spooldir=#{var}/spool/news/leafnode"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leafnode-version")
  end
end
