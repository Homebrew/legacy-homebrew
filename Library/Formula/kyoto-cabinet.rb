require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.74.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 '345358259ec4e58b5986b5d6fa8f82dfe2816c37'

  def patches
    p = []
    if ENV.compiler == :clang
      p << 'https://gist.github.com/raw/9b24c8fffc234d75b732/f910b0cffd4758312af06974482622e0a9b8b37a/lock.patch'
    end
    p
  end

  def options
  [
    ["--with-libc++", "Link with libc++. Requires clang."]
  ]
  end

  def install

    if ARGV.include? "--with-libc++"
      if ENV.compiler != :clang
        onoe '--use-clang is required for building with libc++'
        exit 1
      else
        ENV.append 'CXXFLAGS', '-std=c++11'
        ENV.append 'CXXFLAGS', '-stdlib=libc++'
      end
    end

    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
