require 'formula'

class St < Formula
  homepage 'https://github.com/nferraz/st'
  url 'https://github.com/nferraz/st/archive/v1.0.2.tar.gz'
  sha1 '9b7c0c197d3b7724d317e9a9afb55d67b1082259'

  head 'https://github.com/nferraz/st.git', :branch => 'master'

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end

  def test
    system "#{bin}/st"
  end
end
