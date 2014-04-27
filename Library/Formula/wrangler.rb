require 'formula'

class Wrangler < Formula
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  url 'https://github.com/RefactoringTools/wrangler/archive/wrangler1.1.01.tar.gz'
  sha1 ''

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
