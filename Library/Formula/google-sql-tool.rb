require 'formula'

class GoogleSqlTool < Formula
  homepage 'https://developers.google.com/cloud-sql/docs/commandline'
  url 'http://dl.google.com/cloudsql/tools/google_sql_tool.zip'
  md5 'dc6a5a88e2163c3f2677c55d5aa502ff'
  version 'r9'

  def install
    # Patch script to find jar
    inreplace 'google_sql.sh',
      'SQL_SH_DIR="$(cd $(dirname $0); pwd)"',
      "SQL_SH_DIR=\"#{libexec}\""

    libexec.install %w(google_sql.sh google_sql.jar)
    bin.install_symlink libexec+('google_sql.sh') => 'google_sql'
  end
end
