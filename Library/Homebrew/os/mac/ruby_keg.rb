require "vendor/macho/macho"

module RubyKeg
  def change_dylib_id(id, file)
    @require_install_name_tool = true
    puts "Changing dylib ID of #{file}\n  from #{file.dylib_id}\n    to #{id}" if ARGV.debug?
    MachO::Tools.change_dylib_id(file, id)
  end

  def change_install_name(old, new, file)
    @require_install_name_tool = true
    puts "Changing install name in #{file}\n  from #{old}\n    to #{new}" if ARGV.debug?
    MachO::Tools.change_install_name(file, old, new)
  end

  def require_install_name_tool?
    !!@require_install_name_tool
  end
end
