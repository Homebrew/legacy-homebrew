require "formula"

class Solr < Formula
  homepage "http://lucene.apache.org/solr/"
  url "http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.10.0/solr-4.10.0.tgz"
  sha1 "ae47a89f35b5e2a6a4e55732cccc64fb10ed9779"

  bottle do
    cellar :any
    sha1 "9c3fe919fd112549b5fbac7b4715a6bcf209b88d" => :mavericks
    sha1 "ad64b5fe509d2f9da244a52f13d9525259604e2f" => :mountain_lion
    sha1 "82bc81371673e7e9e2cafae5d9914dd46ec64e84" => :lion
  end

  def script; <<-EOS.undent
    #!/bin/sh
    if [ -z "$1" ]; then
      echo "Usage: $ solr /absolute/path/to/config/dir"
    else
      cd #{libexec}/example && java -server $JAVA_OPTS -Dsolr.solr.home=$1 -jar start.jar
    fi
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+"solr").write script
  end

  def caveats; <<-EOS.undent
    To start solr:
      solr /absolute/path/to/solr/config/dir

    See the solr homepage for more setup information:
      brew home solr
    EOS
  end
end
