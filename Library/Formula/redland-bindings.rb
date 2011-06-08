require 'formula'

class RedlandBindings < Formula
  url 'http://download.librdf.org/source/redland-bindings-1.0.13.1.tar.gz'
  homepage 'http://librdf.org/bindings/'
  md5 'f65796cdcd75c27a8b9e9c0c797ffb50'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'berkeley-db' => :optional
  depends_on 'redland'

  # Installation will fail if 'python' is installed or if you
  # are within a virtualenv. --> Only works with Apple's python
  # installation

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
			  "--with-python"
    system "make install"
  end
end
