require 'formula'

class Cryptopp < Formula
  homepage 'http://www.cryptopp.com/'
  url 'https://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.2/cryptopp562.zip'
  sha1 'ddc18ae41c2c940317cd6efe81871686846fa293'
  version '5.6.2'

  option 'asm', 'Enable ASM optimizations (ignored by -developer)'

  # Mavericks and Mountain Lion support Intel Core 2 Duo processors and 1st-gen
  # i5 CPU which do not support AVX. Clang defaults vector instructions to
  # host-cpu, which maybe > SSSE3. Accordingly, ssse3 flag is required to
  # build binary which supports older CPUs.
  option 'developer', 'Vector instructions set to SSSE3 for CPU compatibility'

  def install
    cxxflags = ''
    if !build.include? 'asm'
      cxxflags = '-DCRYPTOPP_DISABLE_ASM'
    end

    if build.include? 'developer'
      cxxflags = '-DCRYPTOPP_DISABLE_ASM -DCLANG_X86_VECTOR_INSTRUCTIONS=ssse3'
    end

    ENV.append 'CXXFLAGS', cxxflags

    system "make", "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cxxflags}"
    lib.install "libcryptopp.a"
    (include+'cryptopp').install Dir["*.h"]
  end
end
