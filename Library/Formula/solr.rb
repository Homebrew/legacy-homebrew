require "formula"

class Solr < Formula
  homepage "http://lucene.apache.org/solr/"
  url "http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.10.0/solr-4.10.0.tgz"
  sha1 "ae47a89f35b5e2a6a4e55732cccc64fb10ed9779"

  bottle do
    cellar :any
    revision 1
    sha1 "46526c38f55b53fe84b7693db1a4527c06377c41" => :mavericks
    sha1 "55d249ab831038a38b17908aba0d5193b4c2b7cb" => :mountain_lion
    sha1 "174a83e20f7462f6de0ba7382402f544d01268b6" => :lion
  end

  def install
    libexec.install Dir["*"]
    bin.install "#{libexec}/bin/solr"
    share.install "#{libexec}/bin/solr.in.sh"
    prefix.install "#{libexec}/example"
  end

  def caveats; <<-EOS.undent
    To start solr:
      solr /absolute/path/to/solr/config/dir

    See the solr homepage for more setup information:
      brew home solr
    EOS
  end
end
