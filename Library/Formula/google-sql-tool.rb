require 'formula'

class GoogleSqlTool < Formula
  url 'http://dl.google.com/cloudsql/tools/google_sql_tool.zip'
  version 'r9'
  homepage 'http://code.google.com/apis/sql/'
  md5 'dc6a5a88e2163c3f2677c55d5aa502ff'

  def install
    rm_f Dir["*.cmd"]

    prefix.install "README.txt"
    libexec.install Dir['*']

    inreplace libexec+('google_sql.sh'), 'SQL_SH_DIR="$(cd $(dirname $0); pwd)"', "SQL_SH_DIR=\"#{libexec}\""

    bin.mkpath
    ln_s libexec+('google_sql.sh'), bin
  end
end
