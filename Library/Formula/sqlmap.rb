class Sqlmap < Formula
  desc "Penetration testing for SQL injection and database servers"
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/0.9.tar.gz"
  sha256 "77b2b0ac7844cbb045baa8d477ca11a9f3ca736b7e0b340787c8a181a2fc718f"
  head "https://github.com/sqlmapproject/sqlmap.git"
  revision 1

  bottle :unneeded

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"sqlmap.py"
    bin.install_symlink bin/"sqlmap.py" => "sqlmap"

    if build.head?
      bin.install_symlink libexec/"sqlmapapi.py"
      bin.install_symlink bin/"sqlmapapi.py" => "sqlmapapi"
    end
  end

  test do
    query_path = testpath/"school_insert.sql"
    query_path.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS

    query_select = "select name, age from students order by age asc;"

    # Create the test database
    `sqlite3 < #{query_path} school.sqlite`

    output = `#{bin}/sqlmap --batch -d "sqlite://school.sqlite" --sql-query "#{query_select}"`
    assert_match /Bob,\s14/, output
    assert_match /Sue,\s12/, output
    assert_match /Tim,\s13/, output
  end
end
