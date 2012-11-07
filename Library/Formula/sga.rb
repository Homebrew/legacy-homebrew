require 'formula'

class Sga < Formula
  homepage 'https://github.com/jts/sga'
  url 'https://github.com/jts/sga/tarball/v0.9.35'
  sha1 'e505f46fc6ba0e991096d7d9a9d50d37c94e4d4c'

  head 'https://github.com/jts/sga.git'

  depends_on :autoconf => :build
  depends_on :automake => :build
  # Only header files are used, so :build is appropriate
  depends_on 'google-sparsehash' => :build
  depends_on 'bamtools'

  # Fix two compiler errors. Both fixed upstream.
  def patches
    ['http://github.com/jts/sga/commit/b4efb323ed.diff',
     'https://github.com/jts/sga/commit/dfe74633fb.diff'] unless build.head?
  end

  def install
    cd 'src' do
      system "./autogen.sh"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-bamtools=#{HOMEBREW_PREFIX}"
      system "make install"
    end
  end

  def test
    system "#{bin}/sga", "--version"
  end
end
