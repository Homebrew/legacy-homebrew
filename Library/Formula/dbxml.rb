class Dbxml < Formula
  url "http://download.oracle.com/berkeley-db/dbxml-6.0.17.tar.gz"
  homepage "http://www.oracle.com/us/products/database/berkeley-db/xml/overview/index.html"
  sha1 "fa706a73497bbdc6e026cd83e8a5538dd9468e0c"

  depends_on "xerces-c"
  depends_on "xqilla"
  depends_on "berkeley-db"

  def install
    inreplace "dbxml/configure" do |s|
      s.gsub! "lib/libdb-*.la | sed 's\/.*db-\\\(.*\\\).la", "lib/libdb-*.a | sed 's/.*db-\\(.*\\).a"
      s.gsub! "lib/libdb-*.la", "lib/libdb-*.a"
    end

    Dir.chdir "dbxml" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-xqilla=#{HOMEBREW_PREFIX}",
                            "--with-xerces=#{HOMEBREW_PREFIX}",
                            "--with-berkeleydb=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    assert_match /library version #{Regexp.escape(version)}/, shell_output("#{bin}/dbxml -V")
  end
end
