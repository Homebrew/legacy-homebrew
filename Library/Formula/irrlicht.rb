require 'formula'

class Irrlicht < Formula
  homepage 'http://irrlicht.sourceforge.net/'
  url 'http://downloads.sourceforge.net/irrlicht/irrlicht-1.8.zip'
  sha1 'a24c2183e3c7dd909f92699c373a68382958b09d'

  head 'https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk'

  depends_on :xcode

  fails_with :clang do
    cause <<-EOS.undent
      COpenGLExtensionHandler.h:2390:31: error: expected ')'
              glProgramParameteriEXT((long GLuint)program, pname, value);
    EOS
  end

  def install
    system *%W(xcodebuild -project source/Irrlicht/MacOSX/MacOSX.xcodeproj -configuration Release -target libIrrlicht.a GCC_VERSION=com.apple.compilers.llvmgcc42 -sdk macosx#{MacOS.version})

    lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
    include.install "include" => "irrlicht"
  end
end
