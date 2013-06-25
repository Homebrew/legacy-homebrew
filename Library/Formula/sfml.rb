require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sfml < Formula
  homepage 'http://www.sfml-dev.org'

  version '2.0'
  url 'http://www.sfml-dev.org/download/sfml/2.0/SFML-2.0-sources.zip'
  sha1 'ff8cf290f49e1a1d8517a4a344e9214139da462f'

  head 'https://github.com/LaurentGomila/SFML/archive/master.zip'


  depends_on 'cmake' => :build
  depends_on 'freetype' => :build
  depends_on 'jpeg' => :build
  depends_on 'glew' => :build
  depends_on 'libsndfile' => :build

  # libsndfile depends on them (it is all or none)
  # flac, libogg, libvorbis

  option :universal
  option :static, 'Build Static Libraries'

  option :framework, 'Build Framework'
  option :xcode, 'Install XCode 4 Templates (requires sudo to install)'

  option 'build-examples', 'Build Examples'

#  def patches; DATA; end


  def install
    ENV.universal_binary if build.include? 'universal'

    args = std_cmake_args
    args.delete '-DCMAKE_BUILD_TYPE=None'
    args.push '-DCMAKE_BUILD_TYPE=Release', '-DINSTALL_EXTERNAL_LIBS=FALSE'

    args << '-DBUILD_SHARED_LIBS=FALSE'             if build.include? 'static'
    args << '-DSFML_INSTALL_XCODE4_TEMPLATES=TRUE'  if build.include? 'xcode'
    args << '-DSFML_BUILD_EXAMPLES=TRUE'            if build.include? 'build-examples'

    args.push '-DCMAKE_INSTALL_FRAMEWORK_PREFIX=#{prefix}/Frameworks'
    if build.include? 'framework'
      args.push '-DSFML_BUILD_FRAMEWORKS=TRUE'
    else
      args.push '-DSFML_BUILD_FRAMEWORKS=FALSE'
    end

    system 'cmake', '.', *args
    system 'make install'
  end

  def caveats
    msg = ""
    msg = <<-EOS.undent
      The CMake find-module is available at #{opt_prefix}/share/sfml/cmake/Modules/FindSFML.cmake
      You may need to copy it to #{HOMEBREW_PREFIX}/share/cmake/Modules
    EOS
    msg.concat framework_caveats if build.include? 'framework'
    msg.concat examples_caveats if build.include? 'build-examples'

    msg
  end

  private
    def framework_caveats; <<-EOS.undent
      SFML.framework was installed to:
        #{opt_prefix}/Frameworks/SFML.framework

      To use this Framework with IDEs it must be linked
      to the standard OS X location:
        sudo ln -s #{opt_prefix}/Frameworks/SFML.framework /Library/Frameworks
      EOS
    end

    def examples_caveats; <<-EOS.undent
      The examples were installed to:
        #{opt_prefix}/share/sfml/examples
      EOS
    end
end
