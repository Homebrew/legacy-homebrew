require 'hardware'
require 'os/mac/version'
require 'os/mac/xcode'
require 'os/mac/xquartz'

module OS
  module Mac
    extend self

    ::MacOS = self # compatibility

    # This can be compared to numerics, strings, or symbols
    # using the standard Ruby Comparable methods.
    def version
      @version ||= Version.new(MACOS_VERSION)
    end

    def cat
      version.to_sym
    end

    def locate tool
      # Don't call tools (cc, make, strip, etc.) directly!
      # Give the name of the binary you look for as a string to this method
      # in order to get the full path back as a Pathname.
      (@locate ||= {}).fetch(tool.to_s) do |key|
        @locate[key] = if File.executable?(path = "/usr/bin/#{tool}")
          Pathname.new path
        # Homebrew GCCs most frequently; much faster to check this before xcrun
        # This also needs to be queried if xcrun won't work, e.g. CLT-only
        elsif File.executable?(path = "#{HOMEBREW_PREFIX}/bin/#{tool}")
          Pathname.new path
        else
          # If the tool isn't in /usr/bin or from Homebrew,
          # then we first try to use xcrun to find it.
          # If it's not there, or xcode-select is misconfigured, we have to
          # look in dev_tools_path, and finally in xctoolchain_path, because the
          # tools were split over two locations beginning with Xcode 4.3+.
          xcrun_path = unless Xcode.bad_xcode_select_path?
            path = `/usr/bin/xcrun -find #{tool} 2>/dev/null`.chomp
            # If xcrun finds a superenv tool then discard the result.
            path unless path.include?("Library/ENV")
          end

          paths = %W[#{xcrun_path}
                    #{dev_tools_path}/#{tool}
                    #{xctoolchain_path}/usr/bin/#{tool}]
          paths.map { |p| Pathname.new(p) }.find { |p| p.executable? }
        end
      end
    end

    def dev_tools_prefix
      @dev_tools_prefix ||= if tools_in_prefix? CLT::MAVERICKS_PKG_PATH
        Pathname.new CLT::MAVERICKS_PKG_PATH
      elsif tools_in_prefix? "/"
        # probably a safe enough assumption (the unix way)
        Pathname.new "/"
      elsif not Xcode.bad_xcode_select_path? and not `/usr/bin/xcrun -find make 2>/dev/null`.empty?
        # Note that the exit status of system "xcrun foo" isn't always accurate
        # Wherever "make" is there are the dev tools.
        Pathname.new(`/usr/bin/xcrun -find make`.chomp.sub('/usr/bin/make', ''))
      elsif File.exist? "#{Xcode.prefix}/usr/bin/make"
        # cc stopped existing with Xcode 4.3, there are c89 and c99 options though
        Pathname.new Xcode.prefix
      end
    end

    def dev_tools_path
      @dev_tools_path ||= if File.exist? "#{dev_tools_prefix}/usr/bin/make"
        Pathname.new "#{dev_tools_prefix}/usr/bin"
      end
    end

    def tools_in_prefix?(prefix)
      %w{cc make}.all? { |tool| File.executable? "#{prefix}/usr/bin/#{tool}" }
    end

    def xctoolchain_path
      # As of Xcode 4.3, some tools are located in the "xctoolchain" directory
      @xctoolchain_path ||= begin
        path = Pathname.new("#{Xcode.prefix}/Toolchains/XcodeDefault.xctoolchain")
        # If only the CLT are installed, all tools will be under dev_tools_path,
        # this path won't exist, and xctoolchain_path will be nil.
        path if path.exist?
      end
    end

    def sdk_path(v = version)
      (@sdk_path ||= {}).fetch(v.to_s) do |key|
        opts = []
        # First query Xcode itself
        opts << `#{locate('xcodebuild')} -version -sdk macosx#{v} Path 2>/dev/null`.chomp unless Xcode.bad_xcode_select_path?
        # Xcode.prefix is pretty smart, so lets look inside to find the sdk
        opts << "#{Xcode.prefix}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX#{v}.sdk"
        # Xcode < 4.3 style
        opts << "/Developer/SDKs/MacOSX#{v}.sdk"
        @sdk_path[key] = opts.map { |a| Pathname.new(a) }.detect(&:directory?)
      end
    end

    def default_cc
      cc = locate 'cc'
      Pathname.new(cc).realpath.basename.to_s rescue nil
    end

    def default_compiler
      case default_cc
        when /^gcc/ then :gcc
        when /^llvm/ then :llvm
        when "clang" then :clang
        else
          # guess :(
          if Xcode.version >= "4.3"
            :clang
          elsif Xcode.version >= "4.2"
            :llvm
          else
            :gcc
          end
      end
    end

    def default_cxx_stdlib
      version >= :mavericks ? :libcxx : :libstdcxx
    end

    def gcc_40_build_version
      @gcc_40_build_version ||=
        if (path = locate("gcc-4.0"))
          %x{#{path} --version}[/build (\d{4,})/, 1].to_i
        end
    end
    alias_method :gcc_4_0_build_version, :gcc_40_build_version

    def gcc_42_build_version
      @gcc_42_build_version ||=
        begin
          gcc = MacOS.locate('gcc-4.2') || Formula.factory('apple-gcc42').opt_prefix/'bin/gcc-4.2'
          raise unless gcc.exist?
        rescue
          gcc = nil
        end

        if gcc && gcc.realpath.basename.to_s !~ /^llvm/
          %x{#{gcc} --version}[/build (\d{4,})/, 1].to_i
        end
    end
    alias_method :gcc_build_version, :gcc_42_build_version

    def llvm_build_version
      # for Xcode 3 on OS X 10.5 this will not exist
      # NOTE may not be true anymore but we can't test
      @llvm_build_version ||=
        if (path = locate("llvm-gcc")) && path.realpath.basename.to_s !~ /^clang/
          %x{#{path} --version}[/LLVM build (\d{4,})/, 1].to_i
        end
    end

    def clang_version
      @clang_version ||=
        if (path = locate("clang"))
          %x{#{path} --version}[/(?:clang|LLVM) version (\d\.\d)/, 1]
        end
    end

    def clang_build_version
      @clang_build_version ||=
        if (path = locate("clang"))
          %x{#{path} --version}[%r[clang-(\d{2,})], 1].to_i
        end
    end

    def non_apple_gcc_version(cc)
      return unless path = locate(cc)

      ivar = "@#{cc.gsub(/(-|\.)/, '')}_version"
      return instance_variable_get(ivar) if instance_variable_defined?(ivar)

      `#{path} --version` =~ /gcc-\d.\d \(GCC\) (\d\.\d\.\d)/
      instance_variable_set(ivar, $1)
    end

    # See these issues for some history:
    # http://github.com/mxcl/homebrew/issues/#issue/13
    # http://github.com/mxcl/homebrew/issues/#issue/41
    # http://github.com/mxcl/homebrew/issues/#issue/48
    def macports_or_fink
      paths = []

      # First look in the path because MacPorts is relocatable and Fink
      # may become relocatable in the future.
      %w{port fink}.each do |ponk|
        path = which(ponk)
        paths << path unless path.nil?
      end

      # Look in the standard locations, because even if port or fink are
      # not in the path they can still break builds if the build scripts
      # have these paths baked in.
      %w{/sw/bin/fink /opt/local/bin/port}.each do |ponk|
        path = Pathname.new(ponk)
        paths << path if path.exist?
      end

      # Finally, some users make their MacPorts or Fink directorie
      # read-only in order to try out Homebrew, but this doens't work as
      # some build scripts error out when trying to read from these now
      # unreadable paths.
      %w{/sw /opt/local}.map { |p| Pathname.new(p) }.each do |path|
        paths << path if path.exist? && !path.readable?
      end

      paths.uniq
    end

    def prefer_64_bit?
      Hardware::CPU.is_64_bit? and version > :leopard
    end

    def preferred_arch
      if prefer_64_bit?
        Hardware::CPU.arch_64_bit
      else
        Hardware::CPU.arch_32_bit
      end
    end

    STANDARD_COMPILERS = {
      "2.5"   => { :gcc_40_build => 5370 },
      "3.1.4" => { :gcc_40_build => 5493, :gcc_42_build => 5577 },
      "3.2.6" => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "1.7", :clang_build => 77 },
      "4.0"   => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "2.0", :clang_build => 137 },
      "4.0.1" => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "2.0", :clang_build => 137 },
      "4.0.2" => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "2.0", :clang_build => 137 },
      "4.2"   => { :llvm_build => 2336, :clang => "3.0", :clang_build => 211 },
      "4.3"   => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.3.1" => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.3.2" => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.3.3" => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.4"   => { :llvm_build => 2336, :clang => "4.0", :clang_build => 421 },
      "4.4.1" => { :llvm_build => 2336, :clang => "4.0", :clang_build => 421 },
      "4.5"   => { :llvm_build => 2336, :clang => "4.1", :clang_build => 421 },
      "4.5.1" => { :llvm_build => 2336, :clang => "4.1", :clang_build => 421 },
      "4.5.2" => { :llvm_build => 2336, :clang => "4.1", :clang_build => 421 },
      "4.6"   => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "4.6.1" => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "4.6.2" => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "4.6.3" => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "5.0"   => { :clang => "5.0", :clang_build => 500 },
      "5.0.1" => { :clang => "5.0", :clang_build => 500 },
      "5.0.2" => { :clang => "5.0", :clang_build => 500 },
    }

    def compilers_standard?
      return true unless OS.mac?
      STANDARD_COMPILERS.fetch(Xcode.version.to_s).all? do |method, build|
        send(:"#{method}_version") == build
      end
    rescue IndexError
      onoe <<-EOS.undent
        Homebrew doesn't know what compiler versions ship with your version
        of Xcode (#{Xcode.version}). Please `brew update` and if that doesn't help, file
        an issue with the output of `brew --config`:
          https://github.com/mxcl/homebrew/issues

        Thanks!
      EOS
    end

    def app_with_bundle_id id
      path = mdfind(id).first
      Pathname.new(path) unless path.nil? or path.empty?
    end

    def mdfind id
      return [] unless OS.mac?
      (@mdfind ||= {}).fetch(id.to_s) do |key|
        @mdfind[key] = `/usr/bin/mdfind "kMDItemCFBundleIdentifier == '#{key}'"`.split("\n")
      end
    end

    def pkgutil_info id
      (@pkginfo ||= {}).fetch(id.to_s) do |key|
        @pkginfo[key] = `/usr/sbin/pkgutil --pkg-info "#{key}" 2>/dev/null`.strip
      end
    end
  end
end
