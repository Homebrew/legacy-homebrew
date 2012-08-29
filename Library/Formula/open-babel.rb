require 'formula'

class OasaPythonModule < Requirement
  def message; <<-EOS.undent
    The oasa Python module is required for some operations.
    It can be downloaded from:
      http://bkchem.zirael.org/oasa_en.html
    EOS
  end
  def satisfied?
    args = %W{/usr/bin/env python -c import\ oasa}
    quiet_system *args
  end
end

class OpenBabel < Formula
  homepage 'http://openbabel.org/'
  url 'http://sourceforge.net/projects/openbabel/files/openbabel/2.2.3/openbabel-2.2.3.tar.gz'
  md5 '7ea8845c54d6d3a9be378c78088af804'

  head 'https://openbabel.svn.sourceforge.net/svnroot/openbabel/openbabel/trunk'

  depends_on OasaPythonModule.new

  def options
    [
      ["--perl", "Perl bindings"],
      ["--python", "Python bindings"],
      ["--ruby", "Ruby bindings"]
    ]
  end

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << '--enable-maintainer-mode' if ARGV.build_head?

    system "./configure", *args
    system "make"
    system "make install"

    ENV['OPENBABEL_INSTALL'] = prefix

    # Install the python bindings
    if ARGV.include? '--python'
      cd 'scripts/python' do
        system "python", "setup.py", "build"
        system "python", "setup.py", "install", "--prefix=#{prefix}"
      end
    end

    # Install the perl bindings.
    if ARGV.include? '--perl'
      cd 'scripts/perl' do
        # because it's not yet been linked, the perl script won't find the newly
        # compiled library unless we pass it in as LD_LIBRARY_PATH.
        ENV['LD_LIBRARY_PATH'] = "lib"
        system 'perl', 'Makefile.PL'
        # With the additional argument "PREFIX=#{prefix}" it puts things in #{prefix} (where perl can't find them).
        # Without, it puts them in /Library/Perl/...
        inreplace "Makefile" do |s|
          # Fix the broken Makefile (-bundle not allowed with -dynamiclib).
          # I think this is a SWIG error, but I'm not sure.
          s.gsub! '-bundle ', ''
          # Don't waste time building PPC version.
          s.gsub! '-arch ppc ', ''
          # Don't build i386 version when libopenbabel can't link to it.
          s.gsub! '-arch i386 ', ''
        end
        system "make"
        system "make test"
        system "make install"
      end
    end

    # Install the ruby bindings.
    if ARGV.include? '--ruby'
      cd 'scripts/ruby' do
        system "ruby", "extconf.rb",
               "--with-openbabel-include=#{include}",
               "--with-openbabel-lib=#{lib}"

        # Don't build i386 version when libopenbabel can't link to it.
        inreplace "Makefile", '-arch i386 ', ''

        # With the following line it puts things in #{prefix} (where ruby can't find them).
        # Without, it puts them in /Library/Ruby/...
        #ENV['DESTDIR']=prefix
        system "make"
        system "make install"
      end
    end
  end
end
