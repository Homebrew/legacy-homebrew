require 'formula'

class Cpansearch < Formula
  homepage 'https://github.com/c9s/cpansearch'
  url 'https://github.com/c9s/cpansearch/tarball/0.1.1'
  sha1 '8bfb303cf10b0cfcd09f42b4cb3c3911f37a47ee'

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
