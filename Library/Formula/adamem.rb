require 'formula'

class Adamem <Formula
  head 'git://github.com/adamv/adamem-osx.git', :branch => 'osx-brew'
  homepage 'http://www.komkon.org/~dekogel/adamem.html'

  def startup_script app
    # The executables expect to find system roms in the same directory.
    # We create shim sripts in bin/ that invoke the emulators w/ the full
    # paths to the system roms.
    return <<-END
#!/bin/bash
#{libexec}/#{app} -os7 "#{libexec}/OS7.rom" -eos "#{libexec}/EOS.rom" -wp "#{libexec}/WP.rom" $*
END
  end

  def install
    Dir.chdir 'src' do
      system "make -f Makefile.osx dist"
    end

    libexec.install Dir["dist/*"]

    (bin+'adamem').write startup_script('adamem')
    (bin+'cvem').write startup_script('cvem')
  end

  def caveats
    "Note that AdamEm is an X11 app, and does not support sound."
  end
end
