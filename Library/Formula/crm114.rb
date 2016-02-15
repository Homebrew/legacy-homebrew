class Crm114 < Formula
  desc "Examine, sort, filter or alter logs or data streams"
  homepage "http://crm114.sourceforge.net/"
  url "http://crm114.sourceforge.net/tarballs/crm114-20100106-BlameMichelson.src.tar.gz"
  sha256 "fb626472eca43ac2bc03526d49151c5f76b46b92327ab9ee9c9455210b938c2b"

  bottle do
    cellar :any
    sha256 "d48449acfcd105d07e11c0ac7c47fdb21b88d3346c0b51377b9e44b8c8726073" => :el_capitan
    sha256 "151316bd14f7cfce5cea3b765cf4e7801e31c63b72dd786fb38989d8b9380eb3" => :yosemite
    sha256 "30c0c390671485747b7fd2e19bd8735ccfe3bfaae8864dc361bf2abe917ba342" => :mavericks
  end

  depends_on "tre"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    inreplace "Makefile", "LDFLAGS += -static -static-libgcc", ""
    bin.mkpath
    system "make", "prefix=#{prefix}", "install"
  end
end
