#  Copyright 2009 Max Howell and other contributors.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

module HomebrewEnvExtension
  # -w: keep signal to noise high
  SAFE_CFLAGS_FLAGS = "-w -pipe"

  def setup_build_environment
    # Clear CDPATH to avoid make issues that depend on changing directories
    ENV.delete('CDPATH')

    ENV['MAKEFLAGS']="-j#{Hardware.processor_count}"

    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      # /usr/local is already an -isystem and -L directory so we skip it
      ENV['CPPFLAGS'] = "-isystem #{HOMEBREW_PREFIX}/include"
      ENV['LDFLAGS'] = "-L#{HOMEBREW_PREFIX}/lib"
      # CMake ignores the variables above
      ENV['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
    else
      # ignore existing build vars, thus we should have less bugs to deal with
      ENV['CPPFLAGS'] = ''
      ENV['LDFLAGS'] = ''
    end

    if MACOS_VERSION >= 10.6 or ENV['HOMEBREW_USE_LLVM']
      # you can install Xcode wherever you like you know.
      prefix = `/usr/bin/xcode-select -print-path`.chomp
      prefix = "/Developer" if prefix.to_s.empty?

      ENV['CC'] = "#{prefix}/usr/bin/llvm-gcc"
      ENV['CXX'] = "#{prefix}/usr/bin/llvm-g++"
      cflags = %w{-O4} # link time optimisation baby!
    else
      ENV['CC']="gcc-4.2"
      ENV['CXX']="g++-4.2"
      cflags = ['-O3']
    end
    # in rare cases this may break your builds, as the tool for some reason wants
    # to use a specific linker, however doing this in general causes formula to
    # build more successfully because we are changing CC and many build systems
    # don't react properly to that
    ENV['LD']=ENV['CC']

    # optimise all the way to eleven, references:
    # http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
    # http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
    # http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/i386-and-x86_002d64-Options.html
    if MACOS_VERSION >= 10.6
      case Hardware.intel_family
      when :penryn, :core2
        # no need to add -mfpmath it happens automatically with 64 bit compiles
        cflags << "-march=core2"
      when :core
        cflags<<"-march=prescott"<<"-mfpmath=sse"
      end
    else
      case Hardware.intel_family
      when :penryn, :core2
        cflags<<"-march=nocona"
      when :core
        cflags<<"-march=prescott"
      end
      cflags<<"-mfpmath=sse"
    end
    cflags<<"-mmmx"
    case Hardware.intel_family
    when :nehalem
      cflags<<"-msse4.2"
    when :penryn
      cflags<<"-msse4.1"
    when :core2, :core
      cflags<<"-msse3"
    end

    ENV['CFLAGS'] = ENV['CXXFLAGS'] = "#{cflags*' '} #{SAFE_CFLAGS_FLAGS}"
  end
  
  def deparallelize
    remove 'MAKEFLAGS', /-j\d+/
  end
  alias_method :j1, :deparallelize

  def O3
    # Sometimes O4 just takes fucking forever
    remove_from_cflags /-O./
    append_to_cflags '-O3'
  end
  def O2
    # Sometimes O3 doesn't work or produces bad binaries
    remove_from_cflags /-O./
    append_to_cflags '-O2'
  end
  def Os
    # Sometimes you just want a small one
    remove_from_cflags /-O./
    append_to_cflags '-Os'
  end

  def gcc_4_0_1
    case MACOS_VERSION
    when 10.5
      self['CC']=nil
      self['CXX']=nil
      self['LD']=nil
    when 10.6..11.0
      self['CC']='gcc-4.0'
      self['CXX']='g++-4.0'
      self['LD']=self['CC']
      remove_from_cflags '-march=core2'
      self.O3
    end
    remove_from_cflags '-msse4.1'
    remove_from_cflags '-msse4.2'
  end
  alias_method :gcc_4_0, :gcc_4_0_1

  def gcc_4_2
    # Sometimes you want to downgrade from LLVM to GCC 4.2
    self['CC']="gcc-4.2"
    self['CXX']="g++-4.2"
    self['LD']=self['CC']
    self.O3
  end

  def osx_10_4
    self['MACOSX_DEPLOYMENT_TARGET']="10.4"
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    append_to_cflags('-mmacosx-version-min=10.4')
  end
  def osx_10_5
    self['MACOSX_DEPLOYMENT_TARGET']="10.5"
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    append_to_cflags('-mmacosx-version-min=10.5')
  end

  def minimal_optimization
    self['CFLAGS']=self['CXXFLAGS']="-Os #{SAFE_CFLAGS_FLAGS}"
  end
  def no_optimization
    self['CFLAGS']=self['CXXFLAGS'] = SAFE_CFLAGS_FLAGS
  end

  def libxml2
    append_to_cflags ' -I/usr/include/libxml2'
  end
  def x11
    opoo "You do not have X11 installed, this formula may not build." if not x11_installed?
    
    # CPPFLAGS are the C-PreProcessor flags, *not* C++!
    append 'CPPFLAGS', '-I/usr/X11R6/include'
    append 'LDFLAGS', '-L/usr/X11R6/lib'
    # CMake ignores the variables above
    append 'CMAKE_PREFIX_PATH', '/usr/X11R6', ':'
  end
  alias_method :libpng, :x11
  # we've seen some packages fail to build when warnings are disabled!
  def enable_warnings
    remove_from_cflags '-w'
  end
  # Snow Leopard defines an NCURSES value the opposite of most distros
  # See: http://bugs.python.org/issue6848
  def ncurses_define
    append 'CPPFLAGS', "-DNCURSES_OPAQUE=0"
  end
  # returns the compiler we're using
  def cc
    ENV['CC'] or "gcc"
  end
  def cxx
    ENV['CXX'] or "g++"
  end

  def m64
    append_to_cflags '-m64'
    ENV.append 'LDFLAGS', '-arch x86_64'
  end
  def m32
    append_to_cflags '-m32'
    ENV.append 'LDFLAGS', '-arch i386'
  end

  # i386 and x86_64 only, no PPC
  def universal_binary
    append_to_cflags '-arch i386 -arch x86_64'
    ENV.O3 if self['CFLAGS'].include? '-O4' # O4 seems to cause the build to fail
    ENV.append 'LDFLAGS', '-arch i386 -arch x86_64'
  end

  def prepend key, value, separator = ' '
    unless self[key].to_s.empty?
      self[key] = value + separator + self[key]
    else
      self[key] = value
    end
  end
  def append key, value, separator = ' '
    ref=self[key]
    if ref.nil? or ref.empty?
      self[key]=value
    else
      self[key]=ref + separator + value
    end
  end
  def append_to_cflags f
    append 'CFLAGS', f
    append 'CXXFLAGS', f
  end
  def remove key, value
    return if self[key].nil?
    self[key]=self[key].sub value, '' # can't use sub! on ENV
    self[key]=nil if self[key].empty? # keep things clean
  end
  def remove_from_cflags f
    remove 'CFLAGS', f
    remove 'CXXFLAGS', f
  end
end
