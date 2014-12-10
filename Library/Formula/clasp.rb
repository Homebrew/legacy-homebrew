require 'formula'

class Clasp < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/clasp/3.1.0/clasp-3.1.0-source.tar.gz'
  sha1 '57297b641d6900a639e09c2a1c73549707f337b7'

  bottle do
    cellar :any
    sha1 "b72378ef1072d758c0b67a5efd2c3aa63ce7b6af" => :mavericks
    sha1 "dec30107fa4ad5fcf88ebe566c03b88aed00c28d" => :mountain_lion
    sha1 "47b98da2e221a1387780e3c262b96147efffd61e" => :lion
  end

  option 'with-mt', 'Enable multi-thread support'

  depends_on 'tbb' if build.with? "mt"

  def install
    if build.with? "mt"
      ENV['TBB30_INSTALL_DIR'] = Formula["tbb"].opt_prefix
      build_dir = 'build/release_mt'
    else
      build_dir = 'build/release'
    end

    args = %W[
      --config=release
      --prefix=#{prefix}
    ]
    args << "--with-mt" if build.with? "mt"

    bin.mkpath
    system "./configure.sh", *args
    system "make", "-C", build_dir, "install"
  end
end
