class Slony < Formula
  desc "Master to multiple slaves replication system for PostgreSQL"
  homepage "http://slony.info/"
  url "http://main.slony.info/downloads/2.2/source/slony1-2.2.4.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/slony1-2/slony1-2_2.2.4.orig.tar.bz2"
  sha256 "846a878f50de520d151e7f76a66d9b9845e94beb8820727bf84ab522a73e65b5"

  bottle do
    sha256 "b564b6115b04f398f322d3d6857157380b9eb1bcc4db42b75e368a38d9761927" => :yosemite
    sha256 "34860d3a2fe6fd9d6665982962cc0fb0dff609d623cb7f7037786833aec34ce2" => :mavericks
    sha256 "0afd62d604037398e4d9b32070c6601d75ecacab2582820bb3723970ee7c2bb5" => :mountain_lion
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-debug",
                          "--with-pgconfigdir=#{Formula["postgresql"].opt_bin}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"slon", "-v"
  end
end
