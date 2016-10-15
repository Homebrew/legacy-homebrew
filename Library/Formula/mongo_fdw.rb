require "formula"

class MongoFdw < Formula
  homepage "https://github.com/citusdata/mongo_fdw/"
  url "https://github.com/citusdata/mongo_fdw/archive/v3.0.tar.gz"
  sha1 "d37657be846bd2cfd40fa7e62820a9ca6f425d84"
  version "3.0"
  depends_on "postgresql"

  def install
    system "make"
    system "make", "install"
  end

  test do
    extensions = `psql -c "select * from pg_available_extensions where name = 'mongo_fdw'" postgres`
    assert_match /mongo_fdw/, extensions
  end
end
