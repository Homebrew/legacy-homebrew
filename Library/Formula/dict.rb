class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.12.1/dictd-1.12.1.tar.gz"
  sha256 "a237f6ecdc854ab10de5145ed42eaa2d9b6d51ffdc495f7daee59b05cc363656"

  depends_on "libtool" => :build
  depends_on "libmaa"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<-EOS
server localhost
server dict.org
EOS
  end
end
