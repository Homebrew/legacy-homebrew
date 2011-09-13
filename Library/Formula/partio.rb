require 'formula'

class Partio < Formula
  head 'https://github.com/wdas/partio.git'
  homepage 'https://github.com/wdas/partio'

  depends_on 'scons' => :build
  depends_on 'doxygen' => :build

  def install
      system "scons", "-j", "#{Hardware.processor_count}", 
                      "--prefix", "#{prefix}"

      bin.install Dir['bin/*']
      include.install Dir['include/*']
      lib.install Dir['lib/*']
  end
end
