require 'formula'

class Clasp < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/clasp/2.1.4/clasp-2.1.4-source.tar.gz'
  sha1 '4c6ec3ee2f68fd5f9b3574ebb5a8b069d65d12df'

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
