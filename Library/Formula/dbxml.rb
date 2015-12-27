class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "http://www.oracle.com/us/products/database/berkeley-db/xml/overview/index.html"
  url "http://download.oracle.com/berkeley-db/dbxml-6.0.18.tar.gz"
  sha256 "5851f60a47920718b701752528a449f30b16ddbf5402a2a5e8cde8b4aecfabc8"

  bottle do
    cellar :any
    sha256 "e61af38290271e289d8f8e0fbb39f727fe6c9999d7a0cc9531caa59d4ed7c90b" => :el_capitan
    sha256 "9b17ab965313607cee1419b5172e81b54a2f1abc951d55471192571a55aa06b9" => :yosemite
    sha256 "7132f822ef547094f01340f3a4324bbf3726ec6ed9b39a569c44b3afd7736f63" => :mavericks
  end

  depends_on "xerces-c"
  depends_on "xqilla"
  depends_on "berkeley-db"

  def install
    inreplace "dbxml/configure" do |s|
      s.gsub! "lib/libdb-*.la | sed 's\/.*db-\\\(.*\\\).la", "lib/libdb-*.a | sed 's/.*db-\\(.*\\).a"
      s.gsub! "lib/libdb-*.la", "lib/libdb-*.a"
    end

    cd "dbxml" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-xqilla=#{HOMEBREW_PREFIX}",
                            "--with-xerces=#{HOMEBREW_PREFIX}",
                            "--with-berkeleydb=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.xml").write <<-EOS.undent
      <breakfast_menu>
        <food>
          <name>Belgian Waffles</name>
          <calories>650</calories>
        </food>
        <food>
          <name>Homestyle Breakfast</name>
          <calories>950</calories>
        </food>
      </breakfast_menu>
    EOS

    (testpath/"dbxml.script").write <<-EOS.undent
      createContainer ""
      putDocument simple "simple.xml" f
      cquery 'sum(//food/calories)'
      print
      quit
    EOS
    assert_equal "1600", shell_output("#{bin}/dbxml -s #{testpath}/dbxml.script").chomp
  end
end
