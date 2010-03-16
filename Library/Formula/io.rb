require 'formula'

class Io <Formula
  head 'git://github.com/stevedekorte/io.git'
  homepage 'http://iolanguage.com/'

  def hardcoded_prefixes; %w[
    addons/Cairo/build.io
    addons/Flux/io/Flux.io
    addons/MySQL/build.io
    addons/SGML/source/libsgml-1.1.4/acgeneral.m4
    addons/SGML/source/libsgml-1.1.4/configure
    addons/SGML/source/libsgml-1.1.4/libsgml.doxy
    addons/SGML/source/libsgml-1.1.4/Makefile
    addons/SGML/source/libsgml-1.1.4/Makefile.in
    addons/SGML/source/libsgml-1.1.4_osx/acgeneral.m4
    addons/SGML/source/libsgml-1.1.4_osx/config/configure
    addons/SGML/source/libsgml-1.1.4_osx/libsgml.doxy
    addons/SGML/source/libsgml-1.1.4_osx/Makefile
    addons/SGML/source/libsgml-1.1.4_osx/Makefile.in
    addons/TagDB/build.io
    build/AddonBuilder.io
    docs/IoGuide.html
    extras/osx/osx.xcodeproj/project.pbxproj
    extras/osxmain/osxmain.xcodeproj/project.pbxproj
    libs/basekit/source/Hash_fnv.c
    libs/basekit/source/Hash_fnv.h
    libs/iovm/source/IoSystem.c
    Makefile
    tools/io/docs2html.io] << 
    'extras/SyntaxHighlighters/Io.tmbundle/Commands/Run Io Program (ioServer).plist'
  end

  def install
    inreplace ['addons/SGML/build.io', 'addons/TagDB/build.io'],
      'sudo ', ''

    inreplace hardcoded_prefixes, '/usr/local', prefix

    system "make vm"
    system "make"
    system "make install"
  end
end
