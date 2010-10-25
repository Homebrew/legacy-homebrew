require 'formula'

class Crankd <Formula
  url 'http://github.com/acdha/pymacadmin/tarball/cb72649'
  md5 '6d6d6ab7d18c7e6ccfb48bd23f80f392'
  homepage 'http://github.com/acdha/pymacadmin'

  def install
    bin.install "bin/crankd.py"
    # man1.install gzip("growlnotify.1")
    mkdir_p prefix+"Library/Application Support"
    cp_r "lib/PyMacAdmin", prefix+"Library/Application Support/crankd"
  end

  def caveats
    if self.installed? and File.exists? prefix+"Library/Application Support/crankd"
      return <<-EOS.undent
        crankd support files were installed to:
          #{prefix}/Library/Application Support/crankd

        You may want to symlink this Framework to a standard OS X location,
        such as:
          ln -s "#{prefix}/Library/Application Support/crankd" "/Library/Application Support"
      EOS
    end
    return nil
  end

end
