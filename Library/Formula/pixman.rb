require 'formula'

class Pixman < Formula
  homepage 'http://www.cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.22.0.tar.gz'
  sha256 '6b7622256e43912fb77fd456b0753f407268d450f5990c8f86e7c6f006e30da0'

  depends_on 'pkg-config' => :build

  def options
    [
      ["--universal", "Builds a universal binary"]
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    if ENV.compiler == :llvm
        if MacOS.xcode_version == "4.1"
            ENV.clang
        else
            ENV.gcc_4_2
        end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gtk=no" # Don't need to build tests
    system "make install"
  end
end
