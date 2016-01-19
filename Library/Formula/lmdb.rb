class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "http://symas.com/mdb/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.14.tar.gz"
  sha256 "6447d7677a991e922e3e811141869421a2b67952586aa68a26e018ea8ee3989c"

  head "git://git.openldap.org/openldap.git", :branch => "mdb.master"

  bottle do
    cellar :any
    revision 1
    sha256 "1ff98cfc65fcea5c494d9bd097500b7977d57a8760da8475c7f053c85f8cb8da" => :el_capitan
    sha256 "49b620b1ddb51161db870b239de4cf699a7d2b97de1e13901e5fdc8d3358394e" => :yosemite
    sha256 "fec09772155dae25a6aec9422e07927e60ad5ef0f3d95b1aca12ba464ed347f6" => :mavericks
    sha256 "3ad74588a349fb8e4bacb63017c52928001d2adf1a41adde0282ba2bb35f3165" => :mountain_lion
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
