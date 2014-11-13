require 'formula'

class Patchutils < Formula
  homepage 'http://cyberelk.net/tim/software/patchutils/'
  url 'http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.3.tar.xz'
  sha1 '89d3f8a454bacede1b9a112b3a13701ed876fcc1'

  # Fix 'filterdiff --exclude-from-file...' crashes
  # https://fedorahosted.org/patchutils/ticket/30
  patch do
    url 'https://fedorahosted.org/patchutils/raw-attachment/ticket/30/0001-Provide-NULL-pointer-to-getline-to-avoid-realloc-ing.patch'
    sha1 'e787c8df1501feea5c895cdf9e8e01441035bdcf'
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
