require 'formula'

class Cpansearch < Formula
  homepage 'https://github.com/c9s/cpansearch'
  url 'https://github.com/c9s/cpansearch/archive/0.1.1.tar.gz'
  sha1 '8ffab37023886f3c1e287de574001ff720c8b1e5'

  head 'https://github.com/c9s/cpansearch.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "make"
    bin.install "cpans"
  end

  def caveats; <<-EOS.undent
    For usage instructions:
        more #{opt_prefix}/README.md
    EOS
  end
end
