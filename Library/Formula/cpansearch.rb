require 'formula'

class Cpansearch < Formula
  homepage 'https://github.com/c9s/cpansearch'
  url 'https://github.com/c9s/cpansearch/tarball/0.1.1'
  md5 '097e8e107b261a5c4f62af7424f08a1f'
  head 'https://github.com/c9s/cpansearch.git', :using => :git

  depends_on 'glib'

  def install
    system "make"
    bin.install "cpans"
  end

  def caveats; <<-EOS.undent
    For usage instructions:
        more #{prefix}/README.md
    EOS
  end
end
