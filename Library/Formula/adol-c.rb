require 'formula'

class AdolC < Formula
  homepage 'https://projects.coin-or.org/ADOL-C'
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.3.0.tgz'
  sha1 'd9124ce0b199cb8b841a9a9ec10d1fb31ed11b49'

  head 'https://projects.coin-or.org/svn/ADOL-C/trunk/', :using => :svn
  # HEAD contains bugfix for NaNs appearing in 2.2.1
  # http://answerpot.com/showthread.php?2997935-sparse_jac+return+unreasonable+NaN's

  # realpath is used in configure to find colpack
  depends_on 'aardvark_shell_utils' => :build
  depends_on 'colpack'

  def install
    # Configure may get automatically regenerated.  So patch configure.ac also.
    inreplace %w(configure configure.ac) do |s|
      s.gsub! "readlink -f", "realpath"
      s.gsub! "lib64", "lib"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-sparse",
                          "--with-colpack=#{HOMEBREW_PREFIX}"
    system "make install"
    system "make test"
  end
end
