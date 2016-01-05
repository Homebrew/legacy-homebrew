require "permission_checker"

module Homebrew
  def fix_permissions
    checker = PermissionChecker.new
    if ARGV.dry_run?
      return if checker.check!
      opoo checker.report
      puts "To fix permissions, run `brew fix-permissions`"
      Homebrew.failed = true
    else
      checker.fix!
    end
  end
end
