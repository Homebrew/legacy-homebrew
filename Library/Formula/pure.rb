require 'formula'

class Pure < Formula
  homepage 'http://purelang.bitbucket.org/'
  url 'https://bitbucket.org/purelang/pure-lang/downloads/pure-0.60.tar.gz'
  sha1 'ef930868e8ba2b8e1a65c782d8b04828c3d0d255'

  bottle do
    sha1 "75cfcd8adf10e49d2d1d8277c74ec2151b2047a5" => :mavericks
    sha1 "017dedafd0e79bd7ae0e782adf8fdbe5a01f9456" => :mountain_lion
    sha1 "f8fd5804cdf52cb45321fedeb5d4ba42a219a08d" => :lion
  end

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'
  depends_on 'mpfr'

  resource 'docs' do
    url 'https://bitbucket.org/purelang/pure-lang/downloads/pure-docs-0.60.tar.gz'
    sha1 '6a5644bc674db8a481c7db5181cf44d6be590645'
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release",
                          "--without-elisp"
    system "make"
    system "make install"
    resource('docs').stage { system "make", "prefix=#{prefix}", "install" }
  end

  test do
    system "#{bin}/pure", "--version"
  end
end
