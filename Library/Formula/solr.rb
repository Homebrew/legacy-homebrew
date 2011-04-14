require 'formula'

class Solr < Formula
  url 'ftp://ftp.fu-berlin.de/unix/www/apache/lucene/solr/3.1.0/apache-solr-3.1.0.tgz'
  homepage 'http://lucene.apache.org/solr/'
  md5 'd7009df28f28a3e616def8035be06790'

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
