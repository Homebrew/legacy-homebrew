require 'formula'

class Csmith < Formula
  homepage 'http://embed.cs.utah.edu/csmith/'
  url 'http://embed.cs.utah.edu/csmith/csmith-2.1.0.tar.gz'
  md5 '3170ce73f0347d82c1206cf145cb49c7'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # 2.1.0 fails install without this
    system "make install"
    runtime = include+"csmith-#{version}/runtime"
    runtime.install Dir['runtime/*.h']
  end

  def caveats
    <<-EOS.undent
      It is recommended that you set the environment variable 'CSMITH_PATH' to
          #{include}/csmith-#{version}
    EOS
  end
end
