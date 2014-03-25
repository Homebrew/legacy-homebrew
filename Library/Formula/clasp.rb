require 'formula'

class Clasp < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/clasp/3.0.1/clasp-3.0.1-source.tar.gz'
  sha1 '23d47997fe1f474785596c17085c32e76ae5d5c1'

  bottle do
    cellar :any
    sha1 "5436ef5b91eab2b90c7ceb1b2d5fd3f7f80287f0" => :mavericks
    sha1 "26681cd8c4d37d1f079866309934aa53be9d4628" => :mountain_lion
    sha1 "bcd2846a95b709ce1e615103eb1f4f12cf580adb" => :lion
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

    cd build_dir do
      system "make install"
    end
  end
end
