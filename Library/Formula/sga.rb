require 'formula'

class Sga < Formula
  homepage 'https://github.com/jts/sga'
  url 'https://github.com/jts/sga/tarball/v0.9.19'
  sha1 '3f33b708ec930335045ab2a25de291a978f1b875'

  head 'https://github.com/jts/sga.git'

  # Only header files are used, so :build is appropriate
  depends_on 'google-sparsehash' => :build
  depends_on 'bamtools'

  def install
    chdir 'src' do
      system "./autogen.sh"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
        "--prefix=#{prefix}", "--with-bamtools=/usr/local"
      system "make install"
    end
  end

  def test
    system "#{bin}/sga", "--version"
  end
end
