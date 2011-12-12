require 'formula'

class AdolC < Formula
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.2.1.tgz'
  homepage 'https://projects.coin-or.org/ADOL-C'
  head 'https://projects.coin-or.org/svn/ADOL-C/trunk/', :using => :svn
  md5 '5fe149865b47f77344ff910702da8b99'
  # HEAD contains bugfix causing NaN to appear in 2.2.1
  # http://answerpot.com/showthread.php?2997935-sparse_jac+return+unreasonable+NaN's

  depends_on 'aardvark_shell_utils' => :build  # for realpath
  depends_on 'colpack'

  def install
    inreplace "configure" do |s|
        s.gsub! "readlink -f", "realpath"
        s.gsub! "lib64", "lib"
    end
    system "./configure", "--prefix=#{prefix}", "--enable-sparse",
                          "--with-colpack="+`brew --prefix colpack`
    system "make install"
    # use "brew -v install adol-c" to see the test results
    system "make test"
  end
end
