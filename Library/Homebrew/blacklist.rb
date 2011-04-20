def blacklisted? name
  case name.downcase
  when 'vim', 'screen', /^rubygems?$/ then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/bin.
    EOS
  when 'libxml', 'libarchive', 'libpcap' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/lib.
    EOS
  when 'libxlst', 'freetype', 'libpng' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/X11/lib.
    However not all build scripts look here, so you may need to call ENV.x11 or
    ENV.libxml2 in your formula's install function.
    EOS
  when 'wxwidgets' then <<-EOS.undent
    An old version of wxWidgets can be found in /usr/X11/lib. However, Homebrew
    does provide a newer version, 2.8.10:

        brew install wxmac
    EOS
  when 'tex', 'tex-live', 'texlive' then <<-EOS.undent
    Installing TeX from source is weird and gross, requires a lot of patches,
    and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

    We recommend using a MacTeX distribution: http://www.tug.org/mactex/
    EOS
  when 'mercurial', 'hg' then <<-EOS.undent
    Install Mercurial with pip:

        easy_install pip && pip install mercurial

    Or easy_install:

        easy_install mercurial
    EOS
  when 'pip' then <<-EOS.undent
    Install pip with easy_install:

        easy_install pip
    EOS
  when 'npm' then <<-EOS.undent
    npm can be installed thusly by following the instructions at
      http://npmjs.org/

    To do it in one line, use this command:
      curl http://npmjs.org/install.sh | sh
    EOS
  end
end
