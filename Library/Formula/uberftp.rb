require 'formula'

class Uberftp < Formula
  homepage 'http://dims.ncsa.illinois.edu/set/uberftp/'
  url 'https://github.com/JasonAlt/UberFTP/archive/Version_2_7.tar.gz'
  sha1 'f185e2ed567eca3484ca230e44a6ffdb4ec69792'
  version '2.7'

  depends_on 'globus-toolkit'

  def install
    # get the flavor
    if (`#{HOMEBREW_PREFIX}/sbin/gpt-query globus_core | grep gcc64dbg`!="")
        flavor = "gcc64dbg" 
    elsif (`#{HOMEBREW_PREFIX}/sbin/gpt-query globus_core | grep gcc32dbg`!="")
        flavor = "gcc32dbg"
    else
        flavor = ""
    end
    
    system "./configure", "--prefix=#{prefix}", "--with-globus-flavor=#{flavor}", "--with-globus=#{Formula.factory('globus-toolkit').opt_prefix}"
    system "make"
    system "make install"
  end

  test do
      system "#{bin}/uberftp", "-v"
  end
end
