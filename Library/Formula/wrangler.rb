require 'formula'

class Wrangler < Formula
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  url 'http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.9/wrangler-0.9.3.1.tar.gz'
  md5 '64582d6d2955d739edf6edb255becb91'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
