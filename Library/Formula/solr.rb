require "formula"

class Solr < Formula
  homepage "http://lucene.apache.org/solr/"
  url "http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.10.1/solr-4.10.1.tgz"
  sha1 "6033a9887bbfdd1d8ce1bdafce0d65975cf910d8"

  bottle do
    cellar :any
    sha1 "813b592ac2f8608e4495c6b79e1ecafd63e96421" => :mavericks
    sha1 "5059173bedf5a8a70102ac414c9a43e79ce3c265" => :mountain_lion
    sha1 "6c17714dd9ee85c8bebe8c00adf21219d9f3a804" => :lion
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
