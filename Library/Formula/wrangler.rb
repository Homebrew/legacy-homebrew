require 'formula'

class Wrangler < Formula
  url 'http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.9/wrangler-0.9.2.3.tar.gz'
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  md5 'c300841ca787ab95eb69292f8e12ab67'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
