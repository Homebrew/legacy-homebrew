require 'formula'

class Linklint < Formula
  homepage 'http://linklint.org'
  url 'http://linklint.org/download/linklint-2.3.5.tar.gz'
  sha1 'd2dd384054b39a09c17b69e617f7393e44e98376'

  devel do
    url 'http://linklint.org/download/linklint-2.4.beta.tar.gz'
    sha1 'a159d19b700db52e8a9e2d89a0a8984eb627bf17'
  end

  def install
    mv 'READ_ME.txt', 'README' unless build.devel?

    # fix version number reported by linklint -version in beta
    # note, upstream is abandoned, so inreplace instead of patch
    inreplace "linklint-#{version}", "2.3.1", version if build.devel?

    doc.install "README"
    bin.install "linklint-#{version}" => "linklint"
  end

  test do
    (testpath/'index.html').write('<a href="/">Home</a>')
    system "#{bin}/linklint", "/"
  end
end
