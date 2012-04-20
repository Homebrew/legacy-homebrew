require 'formula'

class Cpansearch < Formula
  homepage 'https://github.com/c9s/cpansearch'
  url 'https://github.com/c9s/cpansearch/tarball/0.1'
  md5 '470acb92617d77d7c9809effa3edde6d'

  head 'https://github.com/c9s/cpansearch.git'

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
