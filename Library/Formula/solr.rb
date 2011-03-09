require 'formula'

class Solr <Formula
  url 'ftp://ftp.fu-berlin.de/unix/www/apache/lucene/solr/1.4.1/apache-solr-1.4.1.tgz'
  homepage 'http://lucene.apache.org/solr/'
  md5 '258a020ed8c3f44e13b09e8ae46a1c84'

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
      $ solr path/to/solr/config/dir

    See the solr homepage for more setup information:
      $ brew home solr
    EOS
  end
end
