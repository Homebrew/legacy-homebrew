require 'utils'

Dir.chdir HOMEBREW_REPOSITORY + "Library/Homebrew/test"

$tests_passed = true

def test t
  test_passed = system "/usr/bin/ruby test_#{t}.rb"
  $tests_passed &&= test_passed
  puts; puts "#" * 80; puts
end

test "bucket"
test "formula"
test "versions"
test "checksums"
test "inreplace"
test "hardware"
test "formula_install"
test "patching"
test "external_deps"
test "pathname_install"
test "utils"
test "ARGV"
test "ENV"
test "updater"
test "string"

exit $tests_passed ? 0 : 1