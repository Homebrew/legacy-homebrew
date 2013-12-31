require 'formula'

class PostgresqlJdbc3 < Formula
  homepage 'http://jdbc.postgresql.org/about/about.html'
  url 'http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc3.jar'
  sha1 '682c1724724a2fbbd338ba9336686696558e2a5f'
  version '9.3-1100'

  def install
    libexec.install Dir['*.jar']
  end
end
