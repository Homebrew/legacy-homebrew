require 'formula'

class Wrangler <Formula
  url 'http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.8/wrangler-0.8.4.tar.gz'
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  md5 '84466a243b91ea7467296a945fb644fe'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
