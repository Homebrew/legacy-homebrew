require 'formula'

class Juise < Formula
  homepage 'https://github.com/Juniper/juise/wiki'
  url 'https://github.com/Juniper/juise/releases/download/0.6.1/juise-0.6.1.tar.gz'
  sha1 '9180619ffc67c7b3ebbdd003d9010328e7513527'

  bottle do
    sha1 "18a4e440aed3d01fc859072e15e99782e7480395" => :mavericks
    sha1 "7878b653f90eec8d1d5f12f5337840bdfe44bcff" => :mountain_lion
    sha1 "7702d03a4a8fba60eb6f878bbf5c9ea34239d119" => :lion
  end

  head do
    url 'https://github.com/Juniper/juise.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  depends_on 'libtool' => :build
  depends_on 'libslax'
  depends_on 'libssh2'
  depends_on 'pcre'
  depends_on 'sqlite'

  def install
    system "sh ./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3-prefix=#{Formula["sqlite"].opt_prefix}",
                          "--enable-libedit"
    system "make install"
  end
end
