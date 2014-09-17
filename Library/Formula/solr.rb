require "formula"

class Solr < Formula
  homepage "http://lucene.apache.org/solr/"
  url "http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.10.0/solr-4.10.0.tgz"
  sha1 "ae47a89f35b5e2a6a4e55732cccc64fb10ed9779"

  def install
    prefix.install Dir["*"]
    # bin.install "#{prefix}/bin/solr"
    share.install "#{bin}/solr.in.sh"
  end

  def caveats; <<-EOS.undent
    This supports the new solr script for quickly getting started with Apache Solr by easily loading any of the examples.

    To start Solr with default example:
      solr start

    To stop Solr:
      solr stop

    Custom Solr configurations:
      SOLR_HOME=/path/to/conf solr start

    See all the options provided with:
      solr -help
      solr start -help

    See the solr homepage for more setup information:
      brew home solr
    EOS
  end
end
