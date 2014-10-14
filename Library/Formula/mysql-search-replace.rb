require "formula"

class MysqlSearchReplace < Formula
  homepage "https://interconnectit.com/products/search-and-replace-for-wordpress-databases/"
  url "https://github.com/interconnectit/Search-Replace-DB/archive/3.0.0.tar.gz"
  sha1 "9778ffcc26fabf85c49bd6ef98b5a80d0d0365f1"

  def install
    libexec.install "srdb.class.php"
    libexec.install "srdb.cli.php" => "srdb"
    chmod 0755, libexec/"srdb"
    bin.install_symlink libexec/"srdb"
  end

  test do
    system bin/"srdb", "--help"
  end
end
