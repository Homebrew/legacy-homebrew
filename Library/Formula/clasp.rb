require 'formula'

class Clasp < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/clasp/3.0.1/clasp-3.0.1-source.tar.gz'
  sha1 '23d47997fe1f474785596c17085c32e76ae5d5c1'

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

    cd build_dir do
      system "make install"
    end
  end
end
