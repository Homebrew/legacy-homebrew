
def migrate_remote!
  # only perform the migration when invoked by update.rb or update-report.rb
  return unless Kernel.caller.any? { |f| f.include?("update") }
  oh1 "Migrating Homebrew to v0.9.9"
  exec HOMEBREW_BREW_FILE, "update"
end

migrate_remote!
