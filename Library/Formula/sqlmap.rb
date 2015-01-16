class Sqlmap < Formula
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/0.9.tar.gz"
  sha1 "25d7c13fc6e8bb55a1b4d9ba60a7ebd558ad0374"
  head "https://github.com/sqlmapproject/sqlmap.git"
  revision 1

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

  def caveats; <<-EOS.undent
    The current version of sqlmap (0.9) is very outdated (April 2011) and
    project developers recommend to use the latest version from the
    repository.

    You can do this with:
      brew reinstall --HEAD sqlmap
    EOS
  end unless build.head?
end
