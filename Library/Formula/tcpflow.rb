require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'http://digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.4.tar.gz'
  sha1 'e4bc5ad08a81a39943bd1c799edefcdee09de784'

  head do
    url 'https://github.com/simsong/tcpflow.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'boost' => :build
  depends_on 'sqlite' if MacOS.version < :lion
  depends_on "openssl"

  # Upstream fix for 10.6; can be removed in next release
  patch do
    url "https://github.com/simsong/tcpflow/commit/1cd5a9168c2ebf72c1fadcd64634398bd8470bce.diff"
    sha1 "5264d287a5e62b647da0aa6f2bfa237bc8171c3a"
  end

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
