require 'formula'

class St < Formula
  homepage 'https://github.com/nferraz/st'
  url 'https://github.com/nferraz/st/archive/v1.0.8.tar.gz'
  sha1 'cb85e1fba35aeeafe347088ccae910f9072bf91e'

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
  end
end
