require 'formula'

class Fuseki < Formula
  homepage 'http://jena.apache.org/documentation/serving_data/'
  url "http://www.apache.org/dist/jena/binaries/jena-fuseki-1.0.0-distribution.tar.gz"
  version "1.0.0"
  sha1 '94349d9795a20cabb8b4f5887fc1b341b08cc271'

  def install
    # Remove windows files
    rm_f Dir["*.bat"]

    # Remove init.d script to avoid confusion
    rm 'fuseki'

    # Write the installation path into the wrapper shell script
    inreplace 'fuseki-server', /export FUSEKI_HOME=.+/, "export FUSEKI_HOME=\"#{prefix}\""

    # Move binaries into place
    bin.install 'fuseki-server'
    bin.install Dir["s-*"]

    # Copy across everything else
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    Quick-start guide:

      1. Start the server:
          fuseki-server --update --mem /ds

      2. Open webadmin:
          open http://localhost:3030/

      3. Import some sample data into the store:
          s-put http://localhost:3030/ds/data default #{prefix}/Data/books.ttl
    EOS
  end

  test do
    system "#{bin}/fuseki-server", '--version'
  end
end
