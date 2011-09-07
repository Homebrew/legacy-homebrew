require 'formula'

class Csmith < Formula
  url 'http://embed.cs.utah.edu/csmith/csmith-2.0.0.tar.gz'
  homepage 'http://embed.cs.utah.edu/csmith/'
  md5 'ab0bee5da4d1c2b55c32789b716846cb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    runtime = include+"csmith-#{version}/runtime"
    runtime.mkdir
    runtime.install Dir['runtime/*.h']
  end

  def caveats
    <<-EOS.undent
      It is recommended that you set the environment variable 'CSMITH_PATH' to
          #{include}/csmith-#{version}
    EOS
  end
end
