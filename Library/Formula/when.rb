require 'formula'

class When < Formula
  homepage 'http://www.lightandmatter.com/when/when.html'
  url 'http://www.lightandmatter.com/when/when_1.1.31-debian-source.tar.gz'
  sha1 '2d986aadac5667b7eb50940a6aa547d50c9f8f82'

  def install
    # Double-gzipped.
    system "tar xvf when_1.1.31.orig.tar.gz"
    cd "when-1.1.31" do
      prefix.install_metafiles
      bin.install 'when'
      man1.install 'when.1'
    end
  end
end
