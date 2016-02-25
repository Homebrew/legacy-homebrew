# This is a hack to force old Homebrew to perform core/formula separation migration.
# On the old system, `brew update` will try to load `tap_migrations.rb` file.
# Instead of returning the migration list, we swap the process to run `brew update`
# second time to perform the migration.
oh1 "Migrating Homebrew to v1.0.0"
exec HOMEBREW_BREW_FILE, "update"
