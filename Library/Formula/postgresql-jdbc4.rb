require 'formula'

class PostgresqlJdbc4 < Formula
  homepage 'http://jdbc.postgresql.org/about/about.html'
  url 'http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc4.jar'
  sha1 'fe6ed26ff71d75ebb99e2ec2123003e05ea16dc5'
  version '9.3-1100'

  def install
    libexec.install Dir['*.jar']
  end
end
