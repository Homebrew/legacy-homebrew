require 'formula'

class Solr < Formula
  homepage 'http://lucene.apache.org/solr/'
  url 'http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.1.0/solr-4.1.0.tgz'
  sha1 '89cce8c7c8d68df20f009a7c04ede423d6fa7c84'

  devel do
    url  'http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.0.0-BETA/apache-solr-4.0.0-BETA.tgz'
    sha1 'b41061400f3c5e0433ae8e01c4a62814be37b712'
    version "4.0.0-BETA"
  end

  def script; <<-EOS.undent
    #!/bin/sh
    if [ -z "$1" ]; then
      echo "Usage: $ solr path/to/config/dir"
    else
      cd #{libexec}/example && java -server $JAVA_OPTS -Dsolr.solr.home=$1 -jar start.jar
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
