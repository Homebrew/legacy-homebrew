module HomebrewEnvExtension
  # -w: keep signal to noise high
  SAFE_CFLAGS_FLAGS = "-w -pipe"

  def setup_build_environment
    # Clear CDPATH to avoid make issues that depend on changing directories
    delete('CDPATH')
    delete('CPPFLAGS')
    delete('LDFLAGS')

    self['MAKEFLAGS'] = "-j#{self.make_jobs}"

    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      # /usr/local is already an -isystem and -L directory so we skip it
      self['CPPFLAGS'] = "-isystem #{HOMEBREW_PREFIX}/include"
      self['LDFLAGS'] = "-L#{HOMEBREW_PREFIX}/lib"
      # CMake ignores the variables above
      self['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
    end

    # llvm allows -O4 however it often fails to link and is very slow
    self['CFLAGS'] = self['CXXFLAGS'] = "-O3 #{SAFE_CFLAGS_FLAGS}"

    self.send self.compiler
    # we must have a working compiler!
    unless File.exist? ENV['CC'] and File.exist? ENV['CXX']
      @compiler = MacOS.default_compiler
      self.send @compiler
      ENV['CC']  = '/usr/bin/cc'
      ENV['CXX'] = '/usr/bin/c++'
    end

    # In rare cases this may break your builds, as the tool for some reason wants
    # to use a specific linker. However doing this in general causes formula to
    # build more successfully because we are changing CC and many build systems
    # don't react properly to that.
    self['LD'] = self['CC']
  end

  def deparallelize
    remove 'MAKEFLAGS', /-j\d+/
  end
  alias_method :j1, :deparallelize

  # recommended by Apple, but, eg. wget won't compile with this flag, so…
  def fast
    remove_from_cflags(/-O./)
    append_to_cflags '-fast'
  end
  def O4
    # LLVM link-time optimization
    remove_from_cflags(/-O./)
    append_to_cflags '-O4'
  end
  def O3
    # Sometimes O4 just takes fucking forever
    remove_from_cflags(/-O./)
    append_to_cflags '-O3'
  end
  def O2
    # Sometimes O3 doesn't work or produces bad binaries
    remove_from_cflags(/-O./)
    append_to_cflags '-O2'
  end
  def Os
    # Sometimes you just want a small one
    remove_from_cflags(/-O./)
    append_to_cflags '-Os'
  end
  def Og
    # Sometimes you want a debug build
    remove_from_cflags(/-O./)
    append_to_cflags '-g -O0'
  end

  def gcc_4_0_1
    self['CC'] = '/usr/bin/gcc-4.0'
    self['CXX'] = '/usr/bin/g++-4.0'
    replace_in_cflags '-O4', '-O3'
    set_cpu_cflags 'nocona -mssse3', :core => 'prescott', :bottle => 'generic'
    @compiler = :gcc
  end
  alias_method :gcc_4_0, :gcc_4_0_1

  def gcc args = {}
    gcc_path = Pathname.new "/usr/bin/gcc-4.2"
    gxx_path = Pathname.new "/usr/bin/g++-4.2"
    self['CC']  = gcc_path.exist? ? gcc_path : HOMEBREW_PREFIX+'bin/gcc-4.2'
    self['CXX'] = gxx_path.exist? ? gxx_path : HOMEBREW_PREFIX+'bin/g++-4.2'
    replace_in_cflags '-O4', '-O3'
    set_cpu_cflags 'core2 -msse4', :penryn => 'core2 -msse4.1', :core2 => 'core2', :core => 'prescott', :bottle => 'generic'
    @compiler = :gcc

    raise "GCC could not be found" if not File.exist? ENV['CC'] \
                                   or (Pathname.new(ENV['CC']).realpath.to_s =~ /llvm/)
  end
  alias_method :gcc_4_2, :gcc

  def llvm
    self['CC']  = "/usr/bin/llvm-gcc"
    self['CXX'] = "/usr/bin/llvm-g++"
    set_cpu_cflags 'core2 -msse4', :penryn => 'core2 -msse4.1', :core2 => 'core2', :core => 'prescott'
    @compiler = :llvm
  end

  def clang args = {}
    self['CC']  = "/usr/bin/clang"
    self['CXX'] = "/usr/bin/clang++"
    replace_in_cflags(/-Xarch_i386 (-march=\S*)/, '\1')
    # Clang mistakenly enables AES-NI on plain Nehalem
    set_cpu_cflags 'native', :nehalem => 'native -Xclang -target-feature -Xclang -aes'
    @compiler = :clang
  end

  def fortran
    if self['FC']
      ohai "Building with an alternative Fortran compiler. This is unsupported."
      self['F77'] = self['FC'] unless self['F77']

      if ARGV.include? '--default-fortran-flags'
        self['FCFLAGS'] = self['CFLAGS'] unless self['FCFLAGS']
        self['FFLAGS'] = self['CFLAGS'] unless self['FFLAGS']
      elsif not self['FCFLAGS'] or self['FFLAGS']
        opoo <<-EOS
No Fortran optimization information was provided.  You may want to consider
setting FCFLAGS and FFLAGS or pass the `--default-fortran-flags` option to
`brew install` if your compiler is compatible with GCC.

If you like the default optimization level of your compiler, ignore this
warning.
        EOS
      end

    elsif `/usr/bin/which gfortran`.chomp.size > 0
      ohai <<-EOS
Using Homebrew-provided fortran compiler.
    This may be changed by setting the FC environment variable.
      EOS
      self['FC'] = `/usr/bin/which gfortran`.chomp
      self['F77'] = self['FC']

      self['FCFLAGS'] = self['CFLAGS']
      self['FFLAGS'] = self['CFLAGS']

    else
      onoe <<-EOS
This formula requires a fortran compiler, but we could not find one by
looking at the FC environment variable or searching your PATH for `gfortran`.
Please take one of the following actions:

  - Decide to use the build of gfortran 4.2.x provided by Homebrew using
        `brew install gfortran`

  - Choose another Fortran compiler by setting the FC environment variable:
        export FC=/path/to/some/fortran/compiler
    Using an alternative compiler may produce more efficient code, but we will
    not be able to provide support for build errors.
      EOS
      exit 1
    end
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
    self['CFLAGS'] = self['CXXFLAGS'] = "-Os #{SAFE_CFLAGS_FLAGS}"
  end
  def no_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = SAFE_CFLAGS_FLAGS
  end

  # Some configure scripts won't find libxml2 without help
  def libxml2
    append 'CPPFLAGS', '-I/usr/include/libxml2'
  end

  def x11
    opoo "You do not have X11 installed, this formula may not build." if not MacOS.x11_installed?

    # There are some config scripts (e.g. freetype) here that should go in the path
    prepend 'PATH', '/usr/X11/bin', ':'
    # CPPFLAGS are the C-PreProcessor flags, *not* C++!
    append 'CPPFLAGS', '-I/usr/X11/include'
    append 'LDFLAGS', '-L/usr/X11/lib'
    # CMake ignores the variables above
    append 'CMAKE_PREFIX_PATH', '/usr/X11', ':'
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

  # Shortcuts for reading common flags
  def cc;      self['CC'] or "gcc";  end
  def cxx;     self['CXX'] or "g++"; end
  def cflags;  self['CFLAGS'];       end
  def cppflags;self['CPPLAGS'];      end
  def ldflags; self['LDFLAGS'];      end

  def m64
    append_to_cflags '-m64'
    append 'LDFLAGS', '-arch x86_64'
  end
  def m32
    append_to_cflags '-m32'
    append 'LDFLAGS', '-arch i386'
  end

  # i386 and x86_64 (no PPC)
  def universal_binary
    append_to_cflags '-arch i386 -arch x86_64'
    replace_in_cflags '-O4', '-O3' # O4 seems to cause the build to fail
    append 'LDFLAGS', '-arch i386 -arch x86_64'

    unless compiler == :clang
      # Can't mix "-march" for a 32-bit CPU  with "-arch x86_64"
      replace_in_cflags(/-march=\S*/, '-Xarch_i386 \0') if Hardware.is_32_bit?
    end
  end

  def prepend key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s
    unless self[key].to_s.empty?
      self[key] = value + separator + self[key]
    else
      self[key] = value
    end
  end

  def append key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s
    unless self[key].to_s.empty?
      self[key] = self[key] + separator + value
    else
      self[key] = value
    end
  end

  def append_to_cflags f
    append 'CFLAGS', f
    append 'CXXFLAGS', f
  end

  def remove key, value
    return if self[key].nil?
    self[key] = self[key].sub value, '' # can't use sub! on ENV
    self[key] = nil if self[key].empty? # keep things clean
  end

  def remove_from_cflags f
    remove 'CFLAGS', f
    remove 'CXXFLAGS', f
  end

  def replace_in_cflags before, after
    %w{CFLAGS CXXFLAGS}.each do |key|
      self[key] = self[key].sub before, after if self[key]
    end
  end

  def set_cpu_cflags default, map = {}
    cflags =~ %r{(-Xarch_i386 )-march=}
    xarch = $1.to_s
    remove_from_cflags %r{(-Xarch_i386 )?-march=\S*}
    remove_from_cflags %r{( -Xclang \S+)+}
    remove_from_cflags %r{-mssse3}
    remove_from_cflags %r{-msse4(\.\d)?}
    append_to_cflags xarch unless xarch.empty?
    # Don't set -msse3 and older flags because -march does that for us
    if ARGV.build_bottle?
      if map.has_key?(:bottle)
        append_to_cflags '-mtune=' + map.fetch(:bottle)
      end
    else
      append_to_cflags '-march=' + map.fetch(Hardware.intel_family, default)
    end
  end

  # actually c-compiler, so cc would be a better name
  def compiler
    # TODO seems that ENV.clang in a Formula.install should warn when called
    # if the user has set something that is tested here

    # test for --flags first so that installs can be overridden on a per
    # install basis. Then test for ENVs in inverse order to flags, this is
    # sensible, trust me
    @compiler ||= if ARGV.include? '--use-gcc'
      :gcc
    elsif ARGV.include? '--use-llvm'
      :llvm
    elsif ARGV.include? '--use-clang'
      :clang
    elsif self['HOMEBREW_USE_CLANG']
      :clang
    elsif self['HOMEBREW_USE_LLVM']
      :llvm
    elsif self['HOMEBREW_USE_GCC']
      :gcc
    else
      MacOS.default_compiler
    end
  end

  # don't use in new code
  # don't remove though, but do add to compatibility.rb
  def use_clang?
    compiler == :clang
  end
  def use_gcc?
    compiler == :gcc
  end
  def use_llvm?
    compiler == :llvm
  end

  def make_jobs
    # '-j' requires a positive integral argument
    if self['HOMEBREW_MAKE_JOBS'].to_i > 0
      self['HOMEBREW_MAKE_JOBS']
    else
      Hardware.processor_count
    end
  end

  def remove_cc_etc
    keys = %w{CC CXX LD CPP CFLAGS CXXFLAGS LDFLAGS CPPFLAGS}
    removed = Hash[*keys.map{ |key| [key, ENV[key]] }.flatten]
    keys.each do |key|
      ENV[key] = nil
    end
    removed
  end
end
