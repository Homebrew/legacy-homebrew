require 'formula'

class Solr < Formula
  homepage 'http://lucene.apache.org/solr/'
  url 'http://www.apache.org/dyn/closer.cgi?path=lucene/solr/3.6.1/apache-solr-3.6.1.tgz'
  sha1 'd9f8a4086fb66e716e526d1a047578efdbdd0ede'

  def script; <<-EOS.undent
    #!/bin/sh
    if [ -z "$1" ]; then
      echo "Usage: $ solr path/to/config/dir"
    else
      cd #{libexec}/example && java -Dsolr.solr.home=$1 -jar start.jar
    fi
    EOS
  end

  def install
    libexec.install Dir['*']
    (bin+'solr').write script
  end

  def caveats; <<-EOS.undent
    To start solr:
      solr path/to/solr/config/dir

    See the solr homepage for more setup information:
      brew home solr
    EOS
  end
end
