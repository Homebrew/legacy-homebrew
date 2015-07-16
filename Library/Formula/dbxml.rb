class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "http://www.oracle.com/us/products/database/berkeley-db/xml/overview/index.html"
  url "http://download.oracle.com/berkeley-db/dbxml-6.0.17.tar.gz"
  sha256 "97c79a850ae92ef4945fcf558fbfed41469dd2bda6ad85bd05837cd428e594e8"

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
    system "curl", "-o", (testpath/"simple.xml"), "http://www.w3schools.com/xml/simple.xml"
    script = testpath/"dbxml.script"
    script.write <<-EOS.undent
      createContainer ""
      putDocument simple "simple.xml" f
      cquery 'sum(//food/calories)'
      print
      quit
    EOS
    assert_equal "4000", shell_output("#{bin}/dbxml -s #{testpath}/dbxml.script").chomp
  end
end
