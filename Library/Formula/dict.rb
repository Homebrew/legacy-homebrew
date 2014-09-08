require "formula"

class Dict < Formula
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.12.1/dictd-1.12.1.tar.gz"
  sha1 "5870cc0f727f89091d0ae8a054b37e891f4cf145"

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
