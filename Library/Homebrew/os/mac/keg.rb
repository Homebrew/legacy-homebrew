require "os/mac/pathname"

module InstallNameToolExtention
  def change_dylib_id(id, file)
    puts "Changing dylib ID of #{file}\n  from #{file.dylib_id}\n    to #{id}" if ARGV.debug?
    install_name_tool("-id", id, file)
  end

  def change_install_name(old, new, file)
    puts "Changing install name in #{file}\n  from #{old}\n    to #{new}" if ARGV.debug?
    install_name_tool("-change", old, new, file)
  end

  def install_name_tool(*args)
    @require_install_name_tool = true
    tool = MacOS.install_name_tool
    system(tool, *args) || raise(ErrorDuringExecution.new(tool, args))
  end

  def require_install_name_tool?
    !!@require_install_name_tool
  end
end


class Keg
  include InstallNameToolExtention

  def mach_o_files
    mach_o_files = []
    path.find do |pn|
      next if pn.symlink? || pn.directory?
      mach_o_files << pn if pn.dylib? || pn.mach_o_bundle? || pn.mach_o_executable?
    end

    mach_o_files
  end

  def each_install_name_for(file, &block)
    dylibs = file.dynamically_linked_libraries
    dylibs.reject! { |fn| fn =~ /^@(loader_|executable_|r)path/ }
    dylibs.each(&block)
  end

  def find_dylib(bad_name)
    return unless lib.directory?
    suffix = "/#{find_dylib_suffix_from(bad_name)}"
    lib.find { |pn| break pn if pn.to_s.end_with?(suffix) }
  end

  def brewed_dylibs
    return @brewed_dylibs if @brewed_dylibs
    scan_dylibs
    @brewed_dylibs
  end

  def system_dylibs
    return @system_dylibs if @system_dylibs
    scan_dylibs
    @system_dylibs
  end

  def broken_dylibs
    return @broken_dylibs if @broken_dylibs
    scan_dylibs
    @broken_dylibs
  end

  private

  # Matches framework references like `XXX.framework/Versions/YYY/XXX` and
  # `XXX.framework/XXX`, both with or without a slash-delimited prefix.
  FRAMEWORK_RX = %r{(?:^|/)(([^/]+)\.framework/(?:Versions/[^/]+/)?\2)$}.freeze

  def find_dylib_suffix_from(bad_name)
    if (framework = bad_name.match(FRAMEWORK_RX))
      framework[1]
    else
      File.basename(bad_name)
    end
  end

  def scan_dylibs
    @brewed_dylibs = Hash.new { |h, k| h[k] = Set.new }
    @system_dylibs = Set.new
    @broken_dylibs = Set.new

    mach_o_files.each do |file|
      each_install_name_for(file) do |dylib|
        begin
          owner = Keg.for Pathname.new(dylib)
        rescue NotAKegError
          @system_dylibs << dylib
        rescue Errno::ENOENT
          @broken_dylibs << dylib
        else
          @brewed_dylibs[owner.name] << dylib
        end
      end
    end
  end
end
