require 'formula'
require 'hardware'

class V8 <Formula
  head 'git://github.com/v8/v8.git'
  homepage 'http://code.google.com/p/v8/'

  depends_on 'scons'

  def install
    arch = Hardware.is_64_bit? ? 'x64' : 'ia32'
    system 'scons', "-j #{Hardware.processor_count}", 'mode=release', 'snapshot=on', "arch=#{arch}", 'sample=shell'
    system 'scons', "-j #{Hardware.processor_count}", 'mode=release', 'snapshot=on', "arch=#{arch}", 'library=shared'

    include.install(Dir['include/*'])
    lib.install(Dir['libv8.*'])

    mv('shell', 'v8')
    bin.install('v8')
  end
end
