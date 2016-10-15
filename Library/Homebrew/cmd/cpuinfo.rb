require 'hardware'

module Homebrew extend self
  def cpuinfo
    %w[type family extmodel cores bits arch_32_bit arch_64_bit universal_archs
        aes? altivec? avx? avx2? sse3? ssse3? sse4? sse4_2?].each { |x|
      puts "#{x}: #{Hardware::CPU.send(x)}"
    }
  end
end
