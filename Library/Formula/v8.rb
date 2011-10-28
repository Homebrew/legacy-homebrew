require 'formula'

class V8 < Formula
  head 'http://v8.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/v8/'

  depends_on 'scons' => :build

  def caveats
    s = "For build options see:\n  brew options v8"

    return s
  end


  def options
    [
     ['--debug',"Include debugging information and assertions in the V8 binary."],
     ['--no-snapshots',"Disable 'snapshots' (saved program states) in V8."],
     ['--shared-libraries',"Build shared rather than static libraries."],
     ['--developer-shell',"Build the V8 JavaScript development shell."]
    ]
  end
  
  def install

    arch = Hardware.is_64_bit? ? 'x64' : 'ia32'

    args = [
            "-j #{ENV.make_jobs}",
            "arch=#{arch}",
            "visibility=default",
            "console=readline",
            (ARGV.include? '--debug')?'mode=debug':'mode=release',
            (ARGV.include? '--no-snapshots')?'snapshot=off':'snapshot=on',
            (ARGV.include? '--shared-libraries')?'library=shared':'library=static',
            (ARGV.include? '--developer-shell')?'d8':'sample=shell'
            ]




    system "scons", *args


    include.install Dir['include/*']
    lib.install Dir['libv8.*']

    if ARGV.include? '--developer-shell'
       bin.install 'd8' => 'v8'
    else
      bin.install 'shell' => 'v8'
    end

    system "install_name_tool -change libv8.dylib #{lib}/libv8.dylib #{bin}/v8"
  end
end
