require "formula"

class Cgdb < Formula
  homepage "https://cgdb.github.io/"
  url "http://cgdb.me/files/cgdb-0.6.8.tar.gz"
  sha1 "0892ae59358fa98264269cf6fe57928314ef7942"

  bottle do
    sha1 "97d618f51a59e82d00e9957e545cbf8c55430919" => :mavericks
    sha1 "4d54ccc422b20a5d5a2bb426dab38ed6f0fbb357" => :mountain_lion
    sha1 "3e2bdb1a3bf2e11741df63c3d13069c844208a2c" => :lion
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula['readline'].opt_prefix}"
    system "make install"
  end
end
