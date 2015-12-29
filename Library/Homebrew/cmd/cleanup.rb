require "cleanup"
require "utils"

module Homebrew
  def cleanup
    if ARGV.named.empty?
      Cleanup.cleanup
    else
      ARGV.resolved_formulae.each { |f| Cleanup.cleanup_formula f }
    end

    if Cleanup.disk_cleanup_size > 0
      disk_space = disk_usage_readable(Cleanup.disk_cleanup_size)
      if ARGV.dry_run?
        ohai "This operation would free approximately #{disk_space} of disk space."
      else
        ohai "This operation has freed approximately #{disk_space} of disk space."
      end
    end
  end
end
