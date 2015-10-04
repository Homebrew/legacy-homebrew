class Apgdiff < Formula
  desc "Another PostgreSQL diff tool"
  homepage "http://www.apgdiff.com/"
  url "http://www.apgdiff.com/download/apgdiff-2.4-bin.zip"
  sha256 "12d95fbb0b8188d7f90e7aaf8bdd29d0eecac26e08d6323624b5b7e3f7c7a3f7"

  head do
    url "https://github.com/fordfrog/apgdiff.git"
    depends_on "ant" => :build
  end

  def install
    jar = "apgdiff-#{version}.jar"

    if build.head?
      system "ant"
      cd "dist" do
        jar = Dir["apgdiff-*.jar"].first
        mv jar, ".."
      end
    end

    libexec.install jar
    bin.write_jar_script libexec/jar, "apgdiff"
  end

  test do
    sql_orig = testpath/"orig.sql"
    sql_new = testpath/"new.sql"

    sql_orig.write <<-EOS.undent
    SET search_path = public, pg_catalog;
    SET default_tablespace = '';
    CREATE TABLE testtable (field1 integer);
    ALTER TABLE public.testtable OWNER TO fordfrog;
    EOS

    sql_new.write <<-EOS.undent
    SET search_path = public, pg_catalog;
    SET default_tablespace = '';
    CREATE TABLE testtable (field1 integer,
      field2 boolean DEFAULT false NOT NULL);
    ALTER TABLE public.testtable OWNER TO fordfrog;
    EOS

    expected = <<-EOS.undent.strip
    ALTER TABLE testtable
    \tADD COLUMN field2 boolean DEFAULT false NOT NULL;
    EOS

    result = pipe_output("#{bin}/apgdiff #{sql_orig} #{sql_new}").strip

    assert_equal result, expected
  end
end
