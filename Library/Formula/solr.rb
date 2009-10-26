require 'formula'

SOLR_START_SCRIPT = <<-end_script
#!/bin/sh
if [ -z "$1" ]; then
  echo "Usage: $ solr path/to/config/dir"
else 
  cd %s/example && java -Dsolr.solr.home=$1 -jar start.jar
fi
end_script

class Solr <Formula
  url 'http://apache.deathculture.net/lucene/solr/1.3.0/apache-solr-1.3.0.tgz'
  homepage 'http://lucene.apache.org/solr/'
  md5 '23774b077598c6440d69016fed5cc810'

  def install
    system "mkdir -p #{prefix}"
    system "mv * #{prefix}"
    (bin+'solr').write(SOLR_START_SCRIPT % prefix)
  end

  def caveats
    <<-END_CAVEATS
To start solr: 
    $ solr path/to/solr/config/dir

See the solr homepage for more setup information:
    $ brew home solr

    END_CAVEATS
  end
end
