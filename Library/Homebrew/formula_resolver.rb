require "pathname"

# Return actual name of some formula at commit commit

class FormulaResolver
  class RenamesSheet
    attr_reader :name
    attr_reader :entries
    sheets = {}

    def initialize(name)
      @name = name
      @entries = []
      File.open(HOMEBREW_LIBRARY/"Homebrew/Renames/#{name}").each do |line|
        entries << line.split(',').each { |e| e.lstrip!; e.chomp! }
      end
    end
  end

  def self.get_sheet(name)
    entries = []
    File.open(HOMEBREW_LIBRARY/"Homebrew/Renames/#{name}").each do |line|
      entries << line.split(',').each { |e| e.lstrip!; e.chomp! }
    end
    entries
  end

  def self.compare(commit_a, commit_b)
    # TODO get rid of comparator or rewrite using git
    commit_a < commit_b
  end

  def self.search_after(name, commit)
    sheet = sheets.fetch(name, get_sheet(name))
    # binary search here
    # TODO replace with library implementation
  end

  def self.get_next_name(name, commit)

  end

  def self.resolve(name, commit)
    while name
      name, commit = search_after(name, commit)
    end

  end
end
