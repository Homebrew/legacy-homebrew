require "testing_env"
require "formula"
require "formula_resolver"

class FormulaResolver
  class Entry
    def <=>(entry)
      return commit <=> entry.commit
    end
  end
end

class EntryTest < Homebrew::TestCase
  def test_parse_from_string
    entry = FormulaResolver::Entry.parse_from_string("newname, 9acf6bbc34660cb62874ce09d00edc924ee460de")
    assert_equal "newname", entry.name
    assert_equal "9acf6bbc34660cb62874ce09d00edc924ee460de", entry.commit
    entry = FormulaResolver::Entry.parse_from_string("newname, 9acf6bbc34660cb62874ce09d00edc924ee460de\n")
    assert_equal "newname", entry.name
    assert_equal "9acf6bbc34660cb62874ce09d00edc924ee460de", entry.commit
  end
end

class SheetTest < Homebrew::TestCase
  include FileUtils

  def test_sheet_core
    renames_dir = HOMEBREW_LIBRARY.join("Renames")
    mkpath renames_dir

    File.open(renames_dir/"a", "a+") do |f|
      "bdfgh".split("").each { |s| f.write("#{s}, #{s}\n") }
    end

    sheet = FormulaResolver::Sheet.new("a")

    entry = FormulaResolver::Entry.parse_from_string("name, a")
    entry_after = sheet.entry_after(entry)
    assert_equal "b", entry_after.name
    assert_equal "b", entry_after.commit
    assert_equal "b", sheet.name_after(entry)

    entry = FormulaResolver::Entry.parse_from_string("name, b")
    entry_after = sheet.entry_after(entry)
    assert_equal "d", entry_after.name
    assert_equal "d", entry_after.commit
    assert_equal "d", sheet.name_after(entry)

    rmtree renames_dir
  end

  def test_sheet_tap
  end
end

class FormulaResolverTest < Homebrew::TestCase
  include FileUtils

  def add_rename(oldname, newname, commit)
    File.open(@renames_dir.join(oldname), "a+") { |f| f.write("#{newname}, #{commit}\n") }
  end

  # a -> b, b -> a, a -> c, d -> b, b -> a, a -> d, c -> a
  def test_resolved_name
    renames_dir = HOMEBREW_LIBRARY.join("Renames")
    mkpath renames_dir

    renames = {}
    renames["a"] = ["b, 1\n", "c, 3\n", "d, 6\n"]
    renames["b"] = ["a, 2\n", "a, 5\n"]
    renames["c"] = ["a, 7\n"]
    renames["d"] = ["b, 4\n"]

    renames.each_key do |key|
      File.open(renames_dir.join(key), "a") do |file|
        renames[key].each do |entry|
          file.write(entry)
        end
      end
    end

    ["a", "b", "a", "c", "c", "c", "c", "a"].each_with_index do |name, commit|
      assert_equal "a", FormulaResolver.new(name, "#{commit}").resolved_name
    end

    rmtree renames_dir
  end

  def test_get_last_commit
  end
end
