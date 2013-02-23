require 'formula'

class Clasp < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/potassco/clasp/2.1.1/clasp-2.1.1-source.tar.gz'
  sha1 '4c2bc5fc4b7c9ccfc461dc86a1d449a337602dfe'

  option 'with-mt', 'Enable multi-thread support'

  depends_on 'tbb' if build.include? 'with-mt'

  def install
    if build.include? 'with-mt'
      ENV['TBB30_INSTALL_DIR'] = Formula.factory("tbb").opt_prefix
      build_dir = 'build/release_mt'
    else
      build_dir = 'build/release'
    end

    args = %W[
      --config=release
      --prefix=#{prefix}
    ]
    args << "--with-mt" if build.include? 'with-mt'

    bin.mkpath
    system "./configure.sh", *args

    cd build_dir do
      system "make install"
    end
  end
end
