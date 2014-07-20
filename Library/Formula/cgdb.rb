require "formula"

class Cgdb < Formula
  homepage "http://cgdb.github.io/"
  url "http://cgdb.me/files/cgdb-0.6.7.tar.gz"
  sha1 "5e29e306502888dd660a9dd55418e5c190ac75bb"

  bottle do
    sha1 "97d618f51a59e82d00e9957e545cbf8c55430919" => :mavericks
    sha1 "4d54ccc422b20a5d5a2bb426dab38ed6f0fbb357" => :mountain_lion
    sha1 "3e2bdb1a3bf2e11741df63c3d13069c844208a2c" => :lion
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula['readline'].opt_prefix}"
    system "make install"
  end
end
