require "formula"

class MongoFdw < Formula
  homepage "https://github.com/citusdata/mongo_fdw/"
  url "https://github.com/citusdata/mongo_fdw/tarball/ed04bd0ba7481fa3e36b6d5eab51e6d8235b5d66"
  sha1 "b050bc3ffe5fc0cc6356e7bd824f454bdefd5364"
  version "1.0"
  depends_on 'postgresql'

  def install
    system "make"
    system "make", "install"
  end

  test do
    extensions = `psql -c "select * from pg_available_extensions where name = 'mongo_fdw'" postgres`
    assert_match /mongo_fdw/, extensions
  end
end
