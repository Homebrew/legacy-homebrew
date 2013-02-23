require 'formula'

class Csmith < Formula
  homepage 'http://embed.cs.utah.edu/csmith/'
  url 'http://embed.cs.utah.edu/csmith/csmith-2.1.0.tar.gz'
  sha1 '2c3c1f5f5e4283af4c835c48dbdaf9431623c45c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # 2.1.0 fails install without this
    system "make install"
    runtime = include+"csmith-#{version}/runtime"
    runtime.install Dir['runtime/*.h']
  end

  def caveats; <<-EOS.undent
    It is recommended that you set the environment variable 'CSMITH_PATH' to
      #{include}/csmith-#{version}
    EOS
  end
end
