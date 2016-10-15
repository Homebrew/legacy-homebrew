require "formula"

class Restli < Formula
  homepage "http://rest.li/"
  url "http://rest.li/releases/restli-tool/0.0.1/restli-0.0.1.tar.gz"
  sha1 "38078f768fe463f39db2f69f896fa428ea7b4123"

  depends_on "giter8"

  def install
    bin.install 'restli'
  end

  def caveats; <<-EOS.undent
    Depends on Giter8, which download the Scala runtime from scala-tools.org
    and the rest of the giter8 binaries the first time you run it.  See giter8
    for details.
EOS
  end

  # tests removed.  Because this depends on giter8, which takes too long to download
  # from scala-tools.org, any meaningful test would also call giter8 and would timeout.
end
