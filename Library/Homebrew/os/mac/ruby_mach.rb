require "vendor/macho/macho"
require "os/mac/architecture_list"

module RubyMachO
  # @private
  def macho
    @macho ||= begin
      MachO.open(to_s)
    end
  end

  # @private
  def mach_data
    @mach_data ||= begin
      machos = []
      mach_data = []

      if MachO.fat_magic?(macho.magic)
        machos = macho.machos
      else
        machos << macho
      end

      machos.each do |m|
        arch = case m.cputype
        when "CPU_TYPE_I386" then :i386
        when "CPU_TYPE_X86_64" then :x86_64
        when "CPU_TYPE_POWERPC" then :ppc7400
        when "CPU_TYPE_POWERPC64" then :ppc64
        else :dunno
        end

        type = case m.filetype
        when "MH_EXECUTE" then :executable
        when "MH_DYLIB" then :dylib
        when "MH_BUNDLE" then :bundle
        else :dunno
        end

        mach_data << { :arch => arch, :type => type }
      end

      mach_data
    rescue
      []
    end
  end

  def archs
    mach_data.map { |m| m.fetch :arch }.extend(ArchitectureListExtension)
  end

  def arch
    case archs.length
    when 0 then :dunno
    when 1 then archs.first
    else :universal
    end
  end

  def universal?
    arch == :universal
  end

  def i386?
    arch == :i386
  end

  def x86_64?
    arch == :x86_64
  end

  def ppc7400?
    arch == :ppc7400
  end

  def ppc64?
    arch == :ppc64
  end

  # @private
  def dylib?
    mach_data.any? { |m| m.fetch(:type) == :dylib }
  end

  # @private
  def mach_o_executable?
    mach_data.any? { |m| m.fetch(:type) == :executable }
  end

  # @private
  def mach_o_bundle?
    mach_data.any? { |m| m.fetch(:type) == :bundle }
  end

  def dynamically_linked_libraries
    macho.linked_dylibs
  end

  def dylib_id
    macho.dylib_id
  end
end
