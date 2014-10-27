require "formula"

class Gcc < Formula
  def arch
    if Hardware::CPU.type == :intel
      if MacOS.prefer_64_bit?
        "x86_64"
      else
        "i686"
      end
    elsif Hardware::CPU.type == :ppc
      if MacOS.prefer_64_bit?
        "powerpc64"
      else
        "powerpc"
      end
    end
  end

  def osmajor
    `uname -r`.chomp
  end

  homepage "http://gcc.gnu.org"
  url "http://ftpmirror.gnu.org/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.9.1/gcc-4.9.1.tar.bz2"
  sha1 "3f303f403053f0ce79530dae832811ecef91197e"

  bottle do
    revision 4
    sha1 "656bbfa4c755ce4956ab1c896983a36abf103afb" => :yosemite
    sha1 "d53fdd72908ca631e811fc058e85542d5a945476" => :mavericks
    sha1 "23b5d413cd1e633fd04e77cef9214bc381313039" => :mountain_lion
  end

  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "without-fortran", "Build without the gfortran compiler"
  # enabling multilib on a host that can't run 64-bit results in build failures
  if OS.mac?
    option "without-multilib", "Build without multilib support" if MacOS.prefer_64_bit?
  else
    option "with-multilib", "Build with multilib support"
  end

  depends_on "binutils" if build.with? "glibc"
  depends_on "glibc" => :optional
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "cloog"
  depends_on "isl"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  if MacOS.version < :leopard && OS.mac?
    # The as that comes with Tiger isn't capable of dealing with the
    # PPC asm that comes in libitm
    depends_on "cctools" => :build
  end

  fails_with :gcc_4_0

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  def pour_bottle?
    MacOS::CLT.installed?
  end

  def version_suffix
    version.to_s.slice(/\d\.\d/)
  end

  # Fix 10.10 issues: https://gcc.gnu.org/viewcvs/gcc?view=revision&revision=215251
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/6c0e48921/Homebrew_Resources/Gcc/gcc1010.diff"
    sha1 "083ec884399218584aec76ab8f2a0db97c12a3ba"
  end

  # Fix config-ml.in: eval: line 160: unexpected EOF while looking for matching `''
  # Fixed upstream.
  patch do
    url "https://gist.githubusercontent.com/sjackman/34fa1081982bda781862/raw/738349d49f4f094cced7cfe287cdcdfcd7207265/52fd2e1.diff"
    sha1 "c1dc9a0669eb48a427fbd0cb6a2c209ca9cbf765"
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    if OS.mac? && MacOS.version < :leopard
      ENV["AS"] = ENV["AS_FOR_TARGET"] = "#{Formula["cctools"].bin}/as"
    end

    # C, C++, ObjC compilers are always built
    languages = %w[c c++ objc obj-c++]

    # Everything but Ada, which requires a pre-existing GCC Ada compiler
    # (gnat) to bootstrap. GCC 4.6.0 add go as a language option, but it is
    # currently only compilable on Linux.
    languages << "fortran" if build.with?("fortran") || build.with?("all-languages")
    languages << "java" if build.with?("java") || build.with?("all-languages")

    args = []
    args << "--build=#{arch}-apple-darwin#{osmajor}" if OS.mac?
    if build.with? "glibc"
      binutils = Formula["binutils"].prefix/"x86_64-unknown-linux-gnu/bin"
      args += [
        "--with-native-system-header-dir=#{HOMEBREW_PREFIX}/include",
        "--with-build-time-tools=#{binutils}",
        "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}",
      ]
    end
    args += [
      "--prefix=#{prefix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-cloog=#{Formula["cloog"].opt_prefix}",
      "--with-isl=#{Formula["isl"].opt_prefix}",
    ]
    args += [
      "--with-system-zlib",
      # This ensures lib, libexec, include are sandboxed so that they
      # don't wander around telling little children there is no Santa
      # Claus.
      "--enable-version-specific-runtime-libs",
    ] if OS.mac?
    args += [
      "--enable-libstdcxx-time=yes",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      # A no-op unless --HEAD is built because in head warnings will
      # raise errors. But still a good idea to include.
      "--disable-werror",
      "--with-pkgversion=Homebrew #{name} #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew/issues",
    ]

    # "Building GCC with plugin support requires a host that supports
    # -fPIC, -shared, -ldl and -rdynamic."
    args << "--enable-plugin" if !OS.mac? || MacOS.version > :tiger

    # Otherwise make fails during comparison at stage 3
    # See: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=45248
    args << "--with-dwarf2" if OS.mac? && MacOS.version < :leopard

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_share}/java/ecj.jar"
    end

    if build.without?("multilib") || !MacOS.prefer_64_bit?
      args << "--disable-multilib"
    else
      args << "--enable-multilib"
    end

    mkdir "build" do
      if OS.mac? && !MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-header's will be appended
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      end

      system "../configure", *args
      system "make", "bootstrap"
      system "make", "install"

      if build.with?("fortran") || build.with?("all-languages")
        bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
      end

      if OS.linux?
        # Create gcc and g++ symlinks
        bin.install_symlink "gcc-#{version_suffix}" => "gcc"
        bin.install_symlink "g++-#{version_suffix}" => "g++"
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Since GCC 4.8 libffi stuff are no longer shipped.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when suffixes are appended, the info pages conflict when
    # install-info is run. TODO fix this.
    info.rmtree

    # Rename java properties
    if build.with?("java") || build.with?("all-languages")
      config_files = [
        "#{lib}/logging.properties",
        "#{lib}/security/classpath.security",
        "#{lib}/i386/logging.properties",
        "#{lib}/i386/security/classpath.security"
      ]
      config_files.each do |file|
        add_suffix file, version_suffix if File.exist? file
      end
    end

    # Move lib64/* to lib/ on Linuxbrew
    lib64 = Pathname.new "#{lib}64"
    if lib64.directory?
      system "mv #{lib64}/* #{lib}/"
      rmdir lib64
      prefix.install_symlink "lib" => "lib64"
    end
  end

  def add_suffix file, suffix
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    if OS.linux?
      # Create cc and c++ symlinks, unless they already exist
      homebrew_bin = Pathname.new "#{HOMEBREW_PREFIX}/bin"
      homebrew_bin.install_symlink "gcc" => "cc" unless (homebrew_bin/"cc").exist?
      homebrew_bin.install_symlink "g++" => "c++" unless (homebrew_bin/"c++").exist?

      # Create the GCC specs file
      # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

      # Locate the specs file
      gcc = "gcc-#{version_suffix}"
      specs = Pathname.new(`#{bin}/#{gcc} -print-libgcc-file-name`).dirname/"specs"
      ohai "Creating the GCC specs file: #{specs}"
      raise "command failed: #{gcc} -print-libgcc-file-name" if $?.exitstatus != 0
      specs_orig = Pathname.new("#{specs}.orig")
      rm_f [specs_orig, specs]

      # Save a backup of the default specs file
      s = `#{bin}/#{gcc} -dumpspecs`
      raise "command failed: #{gcc} -dumpspecs" if $?.exitstatus != 0
      specs_orig.write s

      # Set the library search path
      if build.with?("glibc")
        s += "*link_libgcc:\n-nostdlib -L#{lib}/gcc/x86_64-unknown-linux-gnu/#{version} -L#{HOMEBREW_PREFIX}/lib\n\n"
      else
        s += "*link_libgcc:\n+ -L#{HOMEBREW_PREFIX}/lib\n\n"
      end
      s += "*link:\n+ -rpath #{HOMEBREW_PREFIX}/lib"

      # Set the dynamic linker
      glibc = Formula["glibc"]
      if glibc.installed?
        s += " --dynamic-linker #{glibc.opt_lib}/ld-linux-x86-64.so.2"
      end
      s += "\n\n"
      specs.write s
    end
  end

  def caveats
    if build.with?("multilib") then <<-EOS.undent
      GCC has been built with multilib support. Notably, OpenMP may not work:
        https://gcc.gnu.org/bugzilla/show_bug.cgi?id=60670
      If you need OpenMP support you may want to
        brew reinstall gcc --without-multilib
      EOS
    end
  end

  test do
    if build.with?("fortran") || build.with?("all-languages")
      fixture = <<-EOS.undent
        integer,parameter::m=10000
        real::a(m), b(m)
        real::fact=0.5

        do concurrent (i=1:m)
          a(i) = a(i) + fact*b(i)
        end do
        print *, "done"
        end
      EOS
      (testpath/"in.f90").write(fixture)
      system "#{bin}/gfortran", "-c", "in.f90"
      system "#{bin}/gfortran", "-o", "test", "in.o"
      assert_equal "done", `./test`.strip
    end
  end
end
