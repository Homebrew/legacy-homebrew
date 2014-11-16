require 'formula'

class GoogleSqlTool < Formula
  homepage 'https://developers.google.com/cloud-sql/docs/commandline'
  url 'http://dl.google.com/cloudsql/tools/google_sql_tool.zip'
  sha1 '67111a75a1c37b34527b3954795b179f62e88632'
  version 'r10'

  def install
    # Patch script to find jar
    system "chmod +w google_sql.sh"
    inreplace 'google_sql.sh',
      'SQL_SH_DIR="$(cd $(dirname $0); pwd)"',
      "SQL_SH_DIR=\"#{libexec}\""

    libexec.install %w(google_sql.sh google_sql.jar)
    bin.install_symlink libexec+('google_sql.sh') => 'google_sql'
  end
end
