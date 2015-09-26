class Crm114 < Formula
  desc "Examine, sort, filter or alter logs or data streams"
  homepage "http://crm114.sourceforge.net/"
  url "http://crm114.sourceforge.net/tarballs/crm114-20100106-BlameMichelson.src.tar.gz"
  sha256 "fb626472eca43ac2bc03526d49151c5f76b46b92327ab9ee9c9455210b938c2b"

  depends_on "tre"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    inreplace "Makefile", "LDFLAGS += -static -static-libgcc", ""
    bin.mkpath
    system "make", "prefix=#{prefix}", "install"
  end
end

