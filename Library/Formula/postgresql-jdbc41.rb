require 'formula'

class PostgresqlJdbc41 < Formula
  homepage 'http://jdbc.postgresql.org/about/about.html'
  url 'http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc41.jar'
  sha1 '8f89bd15ef7b9a7db03b13a0d69ace8581916160'
  version '9.3-1100'

  def install
    libexec.install Dir['*.jar']
  end
end
