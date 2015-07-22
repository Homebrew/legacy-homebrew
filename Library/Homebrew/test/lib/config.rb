require "tmpdir"
require "pathname"

HOMEBREW_TEMP = Pathname.new(ENV["HOMEBREW_TEMP"] || Dir.tmpdir)

TEST_TMPDIR = ENV.fetch("HOMEBREW_TEST_TMPDIR") { |k|
  dir = Dir.mktmpdir("homebrew_tests", HOMEBREW_TEMP)
  at_exit { FileUtils.remove_entry(dir) }
  ENV[k] = dir
}

HOMEBREW_PREFIX        = Pathname.new(TEST_TMPDIR).join("prefix")
HOMEBREW_REPOSITORY    = HOMEBREW_PREFIX
HOMEBREW_LIBRARY       = HOMEBREW_REPOSITORY+"Library"
HOMEBREW_LIBRARY_PATH  = Pathname.new(File.expand_path("../../..", __FILE__))
HOMEBREW_LOAD_PATH     = [File.expand_path("..", __FILE__), HOMEBREW_LIBRARY_PATH].join(":")
HOMEBREW_CACHE         = HOMEBREW_PREFIX.parent+"cache"
HOMEBREW_CACHE_FORMULA = HOMEBREW_PREFIX.parent+"formula_cache"
HOMEBREW_CELLAR        = HOMEBREW_PREFIX.parent+"cellar"
HOMEBREW_LOGS          = HOMEBREW_PREFIX.parent+"logs"
