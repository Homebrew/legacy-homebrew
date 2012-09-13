require 'formula'

class Luabind < Formula
  homepage 'http://www.rasterbar.com/products/luabind.html'
  
  url 'https://github.com/luabind/luabind/zipball/8c66030818f0eacbb7356c16776539b55d8c5319'
  version '0.9.1'
  sha1 '37a6b8b74444545dd0c0fcdf8a6746128b40d7a1'

  depends_on 'lua'
  depends_on 'boost'

  option 'build-with-clang', 'Build the library using the clang toolset'

  def patches
    # fixes dylib lookup on OS X and compilation with clang
    "https://raw.github.com/gist/3650292/2f998a3ae89282172b1a9cd15c1096c6fceee0b7/osx.diff"
  end
    
  if build.include? 'build-with-clang' and build.include? 'build-with-gcc'
    onoe "Cannot build using gcc and clang toolset. Specify either one"
    exit 1
  end
    
  def install
    args = [
      "release",
      "install"
    ]

    if build.include? 'build-with-clang'
      args << "--toolset=clang"
    else
      args << "--toolset=darwin"
    end

    system "bjam", *args
  end
end
