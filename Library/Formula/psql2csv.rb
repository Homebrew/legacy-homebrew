class Psql2csv < Formula
  desc "Run a query in psql and output the result as CSV"
  homepage "https://github.com/fphilipe/psql2csv"
  url "https://github.com/fphilipe/psql2csv/archive/v0.8.tar.gz"
  sha256 "266d27baf4ca20b7dd9383efccd4119619e8e7cd1c6a1f246d8cd12534bd4f66"

  bottle :unneeded

  depends_on "postgresql"

  def install
    bin.install "psql2csv"
  end

  test do
    expected = "COPY (SELECT 1) TO STDOUT WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8')"
    output = shell_output(%(#{bin}/psql2csv --dry-run "SELECT 1")).strip
    assert_equal expected, output
  end
end
