require 'formula'

class Wrangler <Formula
  url 'http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.9/wrangler-0.9.0-220910.tar.gz'
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  md5 '0bd06dcc310f91d71b4a99afab6497e3'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
