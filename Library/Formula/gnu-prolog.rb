require 'formula'

class GnuProlog < Formula
  url 'http://gprolog.univ-paris1.fr/gprolog-1.4.0.tar.gz'
  homepage 'http://www.gprolog.org/'
  md5 'cc944e5637a04a9184c8aa46c947fd16'

  skip_clean :all

  def patches
    # OSX x86-64
    "https://gist.github.com/raw/1191268/35db85d5cfe5ecd5699286bdd945856ea9cee1a1/patch-x86_64-darwin.diff"
  end

  def install
    ENV.j1 # make won't run in parallel

    args = ["--prefix=#{prefix}"]

    if MacOS.prefer_64_bit?
      args << "--build=x86_64-apple-darwin" << "--host=x86_64-apple-darwin"
    end

    Dir.chdir 'src' do
      system "./configure", *args
      system "make"
      system "make install-strip"
    end
  end
end

