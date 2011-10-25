require 'formula'

class V8 < Formula
  head 'http://v8.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/v8/'

  depends_on 'scons' => :build

  def options
    [
     ['--debug',"For debugging the V8 JavaScript Engine.  Includes debugging information and assertions in the binary."],
     ['--no-snapshots',"Disable 'snapshots' (saved program states) in V8."],
     ['--shared-libraries',"Build shared rather than static libraries."],
     ['--developer-shell',"Build the V8 developer shell."]
    ]

  def install

    if ARGV.include? '--debug'
      mode = "mode=debug"
    else
      mode = "mode=release"      
    end
    
    if ARGV.include? '--no-snapshots'
      snapshot = "snapshot=off"
    else
      snapshot = "snapshot=on"      
    end

    if ARGV.include? '--shared-libraries'
      library = "library=shared"
    else
      library = "library=static"      
    end

    if ARGV.include? '--d8'
      shell = "d8"
    else
      shell = "sample=shell"      
    end

    

arch = Hardware.is_64_bit? ? 'x64' : 'ia32'

    system "scons", "-j #{Hardware.processor_count}",
                    "arch=#{arch}",
                    mode,
                    snapshot,
                    library,
                    shell,
                    "visibility=default",
                    "console=readline"


    include.install Dir['include/*']
    lib.install Dir['libv8.*']
    bin.install 'shell' => 'v8'

    system "install_name_tool -change libv8.dylib #{lib}/libv8.dylib #{bin}/v8"
  end
end
