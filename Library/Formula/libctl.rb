require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libctl < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/Libctl'
  url 'http://ab-initio.mit.edu/libctl/libctl-3.2.1.tar.gz'
  sha1 '16e17250457631c85b7f5ac3db59bb5259fb5399'

  depends_on 'guile'

  def install
    ENV.fortran

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end
end
