require "formula"

class Lmdb < Formula
  homepage "http://symas.com/mdb/"
  url "https://gitorious.org/mdb/mdb.git", :tag => "LMDB_0.9.14"

  head "git://git.openldap.org/openldap.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha1 "7e7e4fb592dccd7c34553760930a9cc59d58c7fb" => :yosemite
    sha1 "835766327dd8a41e993a7e5e54ca415cceec1f15" => :mavericks
    sha1 "5914b3dfe5980896f5242b67cf66fadfb59a0ce5" => :mountain_lion
  end

  def install
    inreplace "libraries/liblmdb/Makefile" do |s|
      s.gsub! ".so", ".dylib"
      s.gsub! "$(DESTDIR)$(prefix)/man/man1", "$(DESTDIR)$(prefix)/share/man/man1"
    end

    man1.mkpath
    bin.mkpath
    lib.mkpath
    include.mkpath

    system "make", "-C", "libraries/liblmdb", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/mdb_dump", "-V"
  end
end
